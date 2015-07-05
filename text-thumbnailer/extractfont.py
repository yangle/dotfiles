#!/usr/bin/env python2
# -*- coding: utf8 -*-

def extract(filename):
    """extract bitmap data from bdf font"""
    from bdflib.reader import read_bdf
    with open(filename, 'r') as f:
        bdf = read_bdf(f)

    # flip both x and y ordering
    font = [[int(bin(row)[2:].rjust(6, '0')[::-1], 2)
             for row in bdf[codepoint].data[::-1]]
            for codepoint in bdf.codepoints()]
    assert len(set(len(data) for data in font)) == 1

    print '\n'.join(' ' * 4 + ' '.join('%2s,' % row for row in data) for data in font)

if __name__ == '__main__':
    extract('Dina_r400-6.bdf')
