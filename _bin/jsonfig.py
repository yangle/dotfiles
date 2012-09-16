#!/usr/bin/env python2

"""JSON representation of matplotlib plot

The idea is to make it easier to fine-tune plots without regenerating all the data,
by introducing another layer of abstraction above matplotlib and storing in JSON the readily-drawable data.

General Rules:
    Do NOT import matplotlib in this file:
        All the actual drawing is done by the draw-json script
    Use _name for internals and unnamed args:
        All the normal members are supposed to be directly fed to matplotlib via **kwargs.
        need to set default values more aggressively, since this is a TEMPLATE for json preparer

Useful Parameters:
    zorder:
        Almost all the drawing commands accept a kwarg "zorder". larger = front, smaller = back
"""

import time
import datetime
import json
import numpy as np

from utils import DotDict as D
from pprint import pprint

infodict={
    'Author': 'Yang-Le Wu',
    'CreationDate': str(datetime.datetime.today()),
    'ModDate': str(datetime.datetime.today()),
}

# TODO: need to add a way to change rc settings, like font size

class NDArrayEncoder(json.JSONEncoder):
    """enable json to serialize numpy array"""
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)

class Figure(D):
    """a matplotlib plot"""
    def __init__(self, figsize=(3.375, 2.2), _figname=None, _infodict=None, **kwargs):
        """initialize a figure

        figsize = (width, height) in inches
        _figname = filename for the pdf to be generated later
        _infodict = dict storing the metadata for pdf
        """
        self.figsize = figsize # (width, height) in inches
        self._axes = []
        self._figname = _figname
        self._infodict = D(infodict)
        if isinstance(_infodict, dict):
            self._infodict.update(_infodict)
        self.update(kwargs)

    def add_axes(self, *args, **kwargs):
        """add a single axes

        _lbwh = (left, bottom, width, height) relative to figsize
        """
        self._axes.append(Axes(*args, **kwargs))
        return self._axes[-1]

    def add_subplots(self, nrows=1, ncols=1, **kwargs):
        """add subplots

        nrows = number of rows
        ncols = number of columns
        sharex = share x axis
        sharey = share y axis
        _margin = margin around the figure boundary (relative to figsize)
        _wspace = horizontal (width) margin between subplots
        _hspace = vertical (height) margin between subplots
        DO NOT CHANGE squeeze: squeeze = True ensures that the matplotlib call plt.subplots() returns a flattened list, rather than a list of lists
        """
        d = D(nrows=nrows, ncols=ncols, sharex='col', sharey='row', squeeze=True, subplot_kw=None, _margin=0.005, _wspace=0.02, _hspace=0.01)
        d.update(kwargs)
        self._subplots = d
        self._axes = [Axes() for col in xrange(d.ncols) for row in xrange(d.nrows)]
        return self._axes

    def dumps(self):
        """save to json"""
        return json.dumps(self, cls=NDArrayEncoder, sort_keys=True, indent=4)

class Axes(D):
    """a single axis in a matplotlib plot"""
    def __init__(self, _lbwh=None, **kwargs):
        """initialize an axis

        _lbwh = (left, bottom, width, height) relative to figsize, optional
        """
        self._lbwh = _lbwh
        self._layers = [] # plots, e.g. ax.scatter
        self._texts = [] # overlay texts
        self._axlines = [] # ax.axhline / ax.axvline
        self._settings = D() # ax.set_xxxx
        self.update(kwargs)

    def __getattr__(self, item):
        """Handle ax.set_xxxx with a single parameter"""
        try:
            return self.__getitem__(item)
        except KeyError:
            if not item.startswith('set_'):
                raise AttributeError(item)
            key = item[4:] # method name, after 'set_'
            def setter(*args, **kwargs):
                self._settings.setdefault(key, []).append(D(_args=args, **kwargs))
            return setter

    def text(self, *args, **kwargs):
        """add overlay text: ax.text(x, y, string, ...)

        _transform = unit reference for the (x, y) coordinate. can be ('ax', 'fig', 'data'), or a 2-tuple specifying x and y separately
        for more kwargs, see: http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.text
        """
        self._texts.append(D(_args=args, **kwargs))

    def axhline(self, *args, **kwargs):
        """draw a horizontal line: ax.axhline(y, ...)

        for more kwargs, see: http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.axhline
        """
        self._axlines.append(D(_direction='h', _args=args, **kwargs))

    def axvline(self, *args, **kwargs):
        """draw a horizontal line: ax.axvline(x, ...)

        for more kwargs, see: http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.axvline
        """
        self._axlines.append(D(_direction='v', _args=args, **kwargs))

    # === these are stored in _layers ======
    def scatter(self, *args, **kwargs):
        """create a scatter plot: scatter(x, y, s=20, c='b', marker='o', cmap=None, norm=None, vmin=None, vmax=None, alpha=None, linewidths=None, verts=None, **kwargs)

        for more kwargs, see: http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.scatter
        """
        self._layers.append(D(_type='scatter', _args=args, **kwargs))
        return len(self._layers) - 1 # return the layer index of the current plot (for legend)

    def plot(self, *args, **kwargs):
        """create a plot

        for caller signature and kwargs, see: http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.plot
        """
        self._layers.append(D(_type='plot', _args=args, **kwargs))
        return len(self._layers) - 1 # return the layer index of the current plot (for legend)

    def Line2D(self, *args, **kwargs):
        """draw a line: Line2D(xdata, ydata, linewidth=None, linestyle=None, color=None, marker=None, markersize=None, markeredgewidth=None, markeredgecolor=None, markerfacecolor=None, markerfacecoloralt='none', fillstyle='full', antialiased=None, dash_capstyle=None, solid_capstyle=None, dash_joinstyle=None, solid_joinstyle=None, pickradius=5, drawstyle=None, markevery=None, **kwargs)

        xdata = 1D array
        ydata = 1D array
        for more kwargs, see: http://matplotlib.org/api/artist_api.html#matplotlib.lines.Line2D
        """
        self._layers.append(D(_type='Line2D', _args=args, **kwargs))
        return len(self._layers) - 1 # return the layer index of the current plot (for legend)

    def spectrum(self, *args, **kwargs):
        """a custom wrapper around scatter using red "_" markers, for spectrum plot"""
        default = D(s=3**2, marker='_', edgecolors='r', facecolors='none')
        default.update(kwargs)
        return self.scatter(*args, **default)
    # ==================

    def legend(self, _indices, _labels, **kwargs):
        """create legend

        _indices = list of layer indices returned by plotting commands
        _labels = list of strings
        loc = location of the legend
        _alpha = opacity
        _fontsize = font size for legend texts
        scatterpoints = number of scatter symbols for each group in the legend
        for more kwargs, see: http://matplotlib.org/api/pyplot_api.html#matplotlib.pyplot.legend
        see also: http://matplotlib.org/users/legend_guide.html
        """
        assert len(_indices) == len(_labels)
        self._legend = D(_indices=_indices, _labels=_labels)
        default = D(loc='best',
                    scatterpoints=1,
                    fancybox=True, _alpha=0.9, shadow=False,
                    _fontsize=6)
        default.update(kwargs)
        for key, value in default.iteritems():
            if key not in self._legend:
                self._legend[key] = value

# ====== tests and examples =======

def test_single_ax(silent=True):
    from random import random
    garbage = lambda length: [random() * .8 for i in xrange(length)]

    fig = Figure(_figname='abc.pdf')
    ax = fig.add_axes()
    handles = [ax.scatter(garbage(4), garbage(4), marker='x') for i in xrange(2)]
    handles += [ax.spectrum(garbage(4), garbage(4)) for i in xrange(2)]
    ax.legend(handles, ['p%s' % i for i in xrange(len(handles))], loc='lower left')
    ax.scatter([0.1, 0.7], [0, 0.71])

    ax.set_xlabel(r'x axis ABCD $AAA\xi$ 0.4 $5\times 5$\\ lol')
    ax.set_ylabel(r'y axis EGFH $\xi\eta$')

    ax.set_xlim([0.1, 1.3])
    ax.set_ylim([-0.3, 1.])

    ax.set_xscale('log')

    ax.text(2e-3, 2e-3, 'wut\nwut?', ha='left', va='bottom', size=4, _transform='fig')
    ax.text(0.5, 0.3, 'lol', ha='left', va='bottom', size=4, _transform='ax')
    ax.text(0.5, 0.3, 'data', ha='left', va='bottom', size=4, _transform='data')

    ax.axhline(0.51, lw=0.3, ls='-', c=[0.5,0.5,0.5])

    ax.axvline(0.1, lw=0.3, ls='-', c=[0.5,0.5,0.5])

    ax.set_title('abc', alpha=0.3)

    if not silent:
        pprint(fig)
    return json.dumps(fig)

def test_subplot(silent=True):
    fig = Figure(_figname='asub.pdf')
    subplots = fig.add_subplots(2, 2)

    x = np.linspace(0, 2 * np.pi, 400)
    y = np.sin(x ** 2)
    subplots[0].scatter(x,y)
    subplots[1].plot(x,y)
    subplots[3].scatter(x,y)

    subplots[2].set_xlabel('abc')
    subplots[3].set_xlabel('abcd')
    subplots[0].set_ylabel('lol')
    subplots[2].set_ylabel('haha')

    subplots[2].set_xticks([0,2,6])
    subplots[3].set_xticks([0,3,6])

    if not silent:
        pprint(fig)
    return fig.dumps()

if __name__ == '__main__':
    print test_single_ax()
    print test_subplot()

