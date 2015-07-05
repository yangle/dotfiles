#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <png.h>

typedef struct
{
    uint8_t r;
    uint8_t g;
    uint8_t b;
    uint8_t a;
} Pixel;

typedef struct
{
    int width;
    int height;
    Pixel* pixels; // [height * width], [width * y + x] = pixel (x, y), with origin at top left corner
} Picture;

// font extracted from Dina_r400-6.bdf -- https://www.donationcoder.com/Software/Jibz/Dina
// [256 * hchar], x-th lowest bit of [c * hchar + y] = the (x, y) pixel of codepoint c
const int WChar = 6; // font size
const int HChar = 10;
static const char Font[2560] = {
     0, 21,  0,  1,  0,  0,  1,  0,  0,  1,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     0,  0,  0, 28, 20, 20, 28,  0,  0,  0,
     4,  4,  4,  4,  7,  0,  0,  0,  0,  0,
     4,  4,  4,  4, 60,  0,  0,  0,  0,  0,
     0,  0,  0,  0, 60,  4,  4,  4,  4,  4,
     0,  0,  0,  0,  7,  4,  4,  4,  4,  4,
     0,  0,  0,  0, 63,  0,  0,  0,  0,  0,
     4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
     4,  4,  4,  4,  7,  4,  4,  4,  4,  4,
     4,  4,  4,  4, 63,  0,  0,  0,  0,  0,
     4,  4,  4,  4, 60,  4,  4,  4,  4,  4,
     0,  0,  0,  0, 63,  4,  4,  4,  4,  4,
     4,  4,  4,  4, 63,  4,  4,  4,  4,  4,
    21, 42, 21, 42, 21, 42, 21, 42, 21, 42,
     0,  0,  0,  8, 31,  4, 31,  2,  0,  0,
     0,  0, 24,  4,  3,  4, 25,  6, 24,  0,
     0,  0,  0, 31, 10, 10, 10, 10,  0,  0,
     0,  0,  3,  4, 24,  4, 19, 12,  3,  0,
     0, 12,  2,  2,  7,  2,  2, 29,  0,  0,
     0,  0,  0,  0,  0, 14,  0,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0,  0,  4,  4,  4,  4,  0,  4,  0,  0,
     0, 10, 10, 10,  0,  0,  0,  0,  0,  0,
     0,  0, 10, 31, 10, 10, 31, 10,  0,  0,
     0,  4, 14,  5, 14, 20, 21, 14,  4,  0,
     0, 19, 11,  8,  4,  2, 26, 25,  0,  0,
     0,  4, 10,  4, 22,  9,  9, 22,  0,  0,
     0,  4,  4,  4,  0,  0,  0,  0,  0,  0,
     0,  8,  4,  2,  2,  2,  2,  2,  4,  8,
     0,  2,  4,  8,  8,  8,  8,  8,  4,  2,
     0,  0,  0, 10,  4, 31,  4, 10,  0,  0,
     0,  0,  0,  4,  4, 31,  4,  4,  0,  0,
     0,  0,  0,  0,  0,  0,  4,  4,  2,  0,
     0,  0,  0,  0,  0, 31,  0,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  4,  4,  0,  0,
     0, 16,  8,  8,  4,  4,  2,  2,  1,  0,
     0,  0, 14, 25, 21, 21, 19, 14,  0,  0,
     0,  0,  4,  6,  5,  4,  4, 31,  0,  0,
     0,  0, 14, 17, 16, 14,  1, 31,  0,  0,
     0,  0, 14, 17, 12, 16, 17, 14,  0,  0,
     0,  0,  8, 12, 10,  9, 31,  8,  0,  0,
     0,  0, 31,  1, 15, 16, 17, 14,  0,  0,
     0,  0, 12,  2, 15, 17, 17, 14,  0,  0,
     0,  0, 31, 16,  8,  4,  2,  2,  0,  0,
     0,  0, 14, 17, 14, 17, 17, 14,  0,  0,
     0,  0, 14, 17, 17, 30, 16, 14,  0,  0,
     0,  0,  0,  4,  4,  0,  4,  4,  0,  0,
     0,  0,  0,  4,  4,  0,  4,  4,  2,  0,
     0,  0,  8,  4,  2,  1,  2,  4,  8,  0,
     0,  0,  0,  0, 31,  0, 31,  0,  0,  0,
     0,  0,  2,  4,  8, 16,  8,  4,  2,  0,
     0,  0, 14, 17,  8,  4,  0,  4,  0,  0,
     0, 14, 17, 25, 21, 21, 25,  1, 30,  0,
     0,  0,  4,  4, 10, 14, 17, 17,  0,  0,
     0,  0, 15, 17, 15, 17, 17, 15,  0,  0,
     0,  0, 14, 17,  1,  1, 17, 14,  0,  0,
     0,  0,  7,  9, 17, 17,  9,  7,  0,  0,
     0,  0, 31,  1,  7,  1,  1, 31,  0,  0,
     0,  0, 31,  1,  7,  1,  1,  1,  0,  0,
     0,  0, 14,  1,  1, 29, 17, 14,  0,  0,
     0,  0, 17, 17, 31, 17, 17, 17,  0,  0,
     0,  0, 14,  4,  4,  4,  4, 14,  0,  0,
     0,  0, 28, 16, 16, 17, 17, 14,  0,  0,
     0,  0, 17,  9,  5,  7,  9, 17,  0,  0,
     0,  0,  1,  1,  1,  1,  1, 31,  0,  0,
     0,  0, 17, 27, 21, 17, 17, 17,  0,  0,
     0,  0, 17, 19, 21, 25, 17, 17,  0,  0,
     0,  0, 14, 17, 17, 17, 17, 14,  0,  0,
     0,  0, 15, 17, 17, 15,  1,  1,  0,  0,
     0,  0, 14, 17, 17, 17,  9, 22, 16,  0,
     0,  0, 15, 17, 15, 17, 17, 17,  0,  0,
     0,  0, 14,  1, 14, 16, 17, 14,  0,  0,
     0,  0, 31,  4,  4,  4,  4,  4,  0,  0,
     0,  0, 17, 17, 17, 17, 17, 14,  0,  0,
     0,  0, 17, 17, 17, 10, 10,  4,  0,  0,
     0,  0, 17, 17, 21, 21, 14, 10,  0,  0,
     0,  0, 17, 10,  4, 10, 17, 17,  0,  0,
     0,  0, 17, 17, 10,  4,  4,  4,  0,  0,
     0,  0, 31,  8,  4,  2,  1, 31,  0,  0,
     0, 14,  2,  2,  2,  2,  2,  2,  2, 14,
     0,  1,  2,  2,  4,  4,  8,  8, 16,  0,
     0, 14,  8,  8,  8,  8,  8,  8,  8, 14,
     0,  4,  4, 10, 10, 17,  0,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0, 63,  0,
     0,  2,  4,  0,  0,  0,  0,  0,  0,  0,
     0,  0,  0, 14, 16, 30, 17, 30,  0,  0,
     0,  1,  1, 15, 17, 17, 17, 15,  0,  0,
     0,  0,  0, 14,  1,  1,  1, 30,  0,  0,
     0, 16, 16, 30, 17, 17, 17, 30,  0,  0,
     0,  0,  0, 14, 17, 31,  1, 30,  0,  0,
     0, 28,  2, 15,  2,  2,  2,  2,  0,  0,
     0,  0,  0, 30, 17, 17, 17, 30, 16, 14,
     0,  1,  1, 15, 17, 17, 17, 17,  0,  0,
     0,  4,  0,  6,  4,  4,  4, 14,  0,  0,
     0,  8,  0, 14,  8,  8,  8,  8,  8,  7,
     0,  1,  1, 17,  9,  7,  9, 17,  0,  0,
     0,  6,  4,  4,  4,  4,  4, 12,  0,  0,
     0,  0,  0, 11, 21, 21, 21, 21,  0,  0,
     0,  0,  0, 15, 17, 17, 17, 17,  0,  0,
     0,  0,  0, 14, 17, 17, 17, 14,  0,  0,
     0,  0,  0, 15, 17, 17, 17, 15,  1,  1,
     0,  0,  0, 30, 17, 17, 17, 30, 16, 16,
     0,  0,  0, 13, 19,  1,  1,  1,  0,  0,
     0,  0,  0, 14,  1, 14, 16, 15,  0,  0,
     0,  2,  2, 15,  2,  2,  2, 28,  0,  0,
     0,  0,  0, 17, 17, 17, 17, 30,  0,  0,
     0,  0,  0, 17, 17, 10, 10,  4,  0,  0,
     0,  0,  0, 17, 17, 21, 21, 10,  0,  0,
     0,  0,  0, 17, 10,  4, 10, 17,  0,  0,
     0,  0,  0, 17, 17, 17, 17, 30, 16, 14,
     0,  0,  0, 31,  8,  4,  2, 31,  0,  0,
     0, 24,  4,  4,  4,  3,  4,  4,  4, 24,
     0,  4,  4,  4,  4,  4,  4,  4,  4,  4,
     0,  3,  4,  4,  4, 24,  4,  4,  4,  3,
     0,  0,  0,  0, 18, 21,  9,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0, 12, 18,  7,  2,  7, 18, 12,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  6,  4,  2,  0,
     0, 24,  4,  4, 14,  4,  4,  4,  4,  3,
     0,  0,  0,  0,  0,  0, 27, 18,  9,  0,
     0,  0,  0,  0,  0,  0,  0, 21,  0,  0,
     0,  0,  4,  4, 31,  4,  4,  4,  4,  4,
     0,  0,  4,  4, 31,  4,  4, 31,  4,  4,
     0,  0,  4, 10,  0,  0,  0,  0,  0,  0,
     0, 19, 11,  4,  2,  1, 27, 27,  0,  0,
    10,  4, 14,  1, 14, 16, 17, 14,  0,  0,
     0,  0,  0,  8,  4,  2,  4,  8,  0,  0,
     0,  0, 30,  5, 13,  5,  5, 30,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    10,  4, 31,  8,  4,  2,  1, 31,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0,  8,  4, 12,  0,  0,  0,  0,  0,  0,
     0,  6,  4,  2,  0,  0,  0,  0,  0,  0,
     0, 18,  9, 27,  0,  0,  0,  0,  0,  0,
     0, 27, 18,  9,  0,  0,  0,  0,  0,  0,
     0,  0,  0,  4, 14, 31, 14,  4,  0,  0,
     0,  0,  0,  0,  0, 14,  0,  0,  0,  0,
     0,  0,  0,  0,  0, 31,  0,  0,  0,  0,
     0,  0, 22, 13,  0,  0,  0,  0,  0,  0,
     0,  0, 31, 26, 26,  0,  0,  0,  0,  0,
    10,  4,  0, 14,  1, 14, 16, 15,  0,  0,
     0,  0,  0,  2,  4,  8,  4,  2,  0,  0,
     0,  0,  0, 10, 21, 13,  5, 26,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    10,  4,  0, 31,  8,  4,  2, 31,  0,  0,
    10,  0, 17, 17, 10,  4,  4,  4,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0,  0,  0,  4,  0,  4,  4,  4,  4,  0,
     0,  4,  4, 14,  5,  5,  5, 30,  4,  4,
     0,  0, 12,  2,  7,  2,  2, 29,  0,  0,
     0,  0,  0, 17, 14, 10, 14, 17,  0,  0,
     0, 17, 17, 10, 31,  4, 31,  4,  0,  0,
     0,  4,  4,  4,  0,  0,  0,  4,  4,  4,
     0, 14,  1,  6,  9, 18, 12, 16, 15,  0,
     0, 10,  0,  0,  0,  0,  0,  0,  0,  0,
     0, 14, 17, 21, 19, 19, 21, 17, 14,  0,
     0,  6,  8, 14,  9, 14,  0,  0,  0,  0,
     0,  0,  0, 20, 10,  5, 10, 20,  0,  0,
     0,  0,  0,  0,  0, 15,  8,  8,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     0, 14, 17, 23, 27, 23, 27, 17, 14,  0,
     0, 63,  0,  0,  0,  0,  0,  0,  0,  0,
     0,  6,  9,  9,  6,  0,  0,  0,  0,  0,
     0,  0,  4,  4, 31,  4,  4, 31,  0,  0,
     0,  6,  8,  4,  2, 14,  0,  0,  0,  0,
     0,  6,  8,  4,  8,  6,  0,  0,  0,  0,
     0,  8,  4,  0,  0,  0,  0,  0,  0,  0,
     0,  0,  0, 18, 18, 18, 22, 10,  2,  1,
     0,  0, 30, 23, 22, 20, 20, 20, 20,  0,
     0,  0,  0,  0, 12, 12,  0,  0,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  4,  8,  6,
     0,  4,  6,  4,  4, 14,  0,  0,  0,  0,
     0,  6,  9,  9,  9,  6,  0,  0,  0,  0,
     0,  0,  0,  5, 10, 20, 10,  5,  0,  0,
     0,  0,  9,  9,  5,  4, 18, 26, 29, 17,
     0,  0,  9,  9,  5,  4, 26, 18,  9, 25,
     0,  1, 10,  9,  6,  5, 18, 26, 29, 17,
     0,  0,  0,  4,  0,  4,  2, 17, 14,  0,
     2,  4,  4,  4, 10, 14, 17, 17,  0,  0,
     8,  4,  4,  4, 10, 14, 17, 17,  0,  0,
     4, 10,  0,  4, 10, 14, 17, 17,  0,  0,
    22, 13,  4,  4, 10, 14, 17, 17,  0,  0,
    10,  0,  4,  4, 10, 14, 17, 17,  0,  0,
     4, 10,  4,  4, 10, 14, 17, 17,  0,  0,
     0,  0, 28,  6, 13,  7,  5, 29,  0,  0,
     0,  0, 14, 17,  1,  1, 17, 14,  4,  2,
     2,  4, 31,  1,  7,  1,  1, 31,  0,  0,
     8,  4, 31,  1,  7,  1,  1, 31,  0,  0,
     4, 10, 31,  1,  7,  1,  1, 31,  0,  0,
    10,  0, 31,  1,  7,  1,  1, 31,  0,  0,
     2,  4, 14,  4,  4,  4,  4, 14,  0,  0,
     8,  4, 14,  4,  4,  4,  4, 14,  0,  0,
     4, 10, 14,  4,  4,  4,  4, 14,  0,  0,
    10,  0, 14,  4,  4,  4,  4, 14,  0,  0,
     0,  0,  6, 10, 23, 18, 10,  6,  0,  0,
    22, 13, 17, 19, 21, 25, 17, 17,  0,  0,
     2,  4, 14, 17, 17, 17, 17, 14,  0,  0,
     8,  4, 14, 17, 17, 17, 17, 14,  0,  0,
     4, 10, 14, 17, 17, 17, 17, 14,  0,  0,
    22, 13, 14, 17, 17, 17, 17, 14,  0,  0,
    10,  0, 14, 17, 17, 17, 17, 14,  0,  0,
     0,  0,  0,  0, 10,  4, 10,  0,  0,  0,
     0, 16, 14, 25, 21, 21, 19, 14,  1,  0,
     2,  4, 17, 17, 17, 17, 17, 14,  0,  0,
     8,  4, 17, 17, 17, 17, 17, 14,  0,  0,
     4, 10, 17, 17, 17, 17, 17, 14,  0,  0,
    10,  0, 17, 17, 17, 17, 17, 14,  0,  0,
     8,  4, 17, 17, 10,  4,  4,  4,  0,  0,
     0,  0,  1, 15, 17, 17, 15,  1,  0,  0,
     0,  0,  6,  9,  5, 25, 17, 13,  0,  0,
     2,  4,  0, 14, 16, 30, 17, 30,  0,  0,
     8,  4,  0, 14, 16, 30, 17, 30,  0,  0,
     4, 10,  0, 14, 16, 30, 17, 30,  0,  0,
    22, 13,  0, 14, 16, 30, 17, 30,  0,  0,
     0, 10,  0, 14, 16, 30, 17, 30,  0,  0,
     4, 10,  4, 14, 16, 30, 17, 30,  0,  0,
     0,  0,  0, 15, 20, 31,  5, 26,  0,  0,
     0,  0,  0, 14,  1,  1,  1, 30,  4,  2,
     2,  4,  0, 14, 17, 15,  1, 30,  0,  0,
     8,  4,  0, 14, 17, 15,  1, 30,  0,  0,
     4, 10,  0, 14, 17, 15,  1, 30,  0,  0,
     0, 10,  0, 14, 17, 15,  1, 30,  0,  0,
     2,  4,  0,  6,  4,  4,  4, 14,  0,  0,
     8,  4,  0,  6,  4,  4,  4, 14,  0,  0,
     4, 10,  0,  6,  4,  4,  4, 14,  0,  0,
     0, 10,  0,  6,  4,  4,  4, 14,  0,  0,
     0, 10,  6,  8, 14, 17, 17, 14,  0,  0,
    22, 13,  0, 15, 17, 17, 17, 17,  0,  0,
     2,  4,  0, 14, 17, 17, 17, 14,  0,  0,
     8,  4,  0, 14, 17, 17, 17, 14,  0,  0,
     4, 10,  0, 14, 17, 17, 17, 14,  0,  0,
    22, 13,  0, 14, 17, 17, 17, 14,  0,  0,
     0, 10,  0, 14, 17, 17, 17, 14,  0,  0,
     0,  0,  0,  4,  0, 31,  0,  4,  0,  0,
     0,  0, 16, 14, 25, 21, 19, 14,  1,  0,
     2,  4,  0, 17, 17, 17, 17, 30,  0,  0,
     8,  4,  0, 17, 17, 17, 17, 30,  0,  0,
     4, 10,  0, 17, 17, 17, 17, 30,  0,  0,
     0, 10,  0, 17, 17, 17, 17, 30,  0,  0,
     8,  4,  0, 17, 17, 17, 17, 30, 16, 14,
     0,  1,  1, 13, 19, 17, 19, 13,  1,  1,
     0, 10,  0, 17, 17, 17, 17, 30, 16, 14,
};

// save picture to png file
void save(Picture pic, const char* path)
{
    FILE* fp = fopen(path, "wb");
    if (!fp)
        return;

    png_structp png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr)
        goto png_create_write_struct_failed;

    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr)
        goto png_create_info_struct_failed;

    if (setjmp(png_jmpbuf(png_ptr)))
        goto png_failed;

    int width = pic.width;
    int height = pic.height;
    int depth = 8;

    png_set_IHDR(png_ptr,
                 info_ptr,
                 width,
                 height,
                 depth,
                 PNG_COLOR_TYPE_RGBA,
                 PNG_INTERLACE_NONE,
                 PNG_COMPRESSION_TYPE_DEFAULT,
                 PNG_FILTER_TYPE_DEFAULT);

    png_byte** row_ptrs = png_malloc(png_ptr, height * sizeof(png_byte*));

    for (int y = 0; y < height; ++y)
    {
        png_byte* row = png_malloc(png_ptr, 4 * sizeof(uint8_t) * width);
        row_ptrs[y] = row;
        for (int x = 0; x < width; ++x)
        {
            Pixel* p = pic.pixels + width * y + x;
            *row++ = p->r;
            *row++ = p->g;
            *row++ = p->b;
            *row++ = p->a;
        }
    }

    png_init_io(png_ptr, fp);
    png_set_rows(png_ptr, info_ptr, row_ptrs);
    png_write_png(png_ptr, info_ptr, PNG_TRANSFORM_IDENTITY, NULL);

    for (int y = 0; y < height; ++y)
        png_free(png_ptr, row_ptrs[y]);
    png_free(png_ptr, row_ptrs);

png_failed:
png_create_info_struct_failed:
    png_destroy_write_struct(&png_ptr, &info_ptr);
png_create_write_struct_failed:
    fclose(fp);
}

// draw thumbnail
//
// pic = target picture
// text = [nrow * ncol], [i * ncol + j] = j-th character on i-th row
void draw(Picture pic, const char* text, int nrow, int ncol)
{
    const int width = pic.width;
    const int height = pic.height;

    // margin from border
    const int xmargin = width / 8;
    const int ymargin = height / 30;

    // padding between chars
    const int xpad = 0;
    const int ypad = 0;

    // white canvas
    for (int y = 0; y < height; ++y)
    {
        for (int x = xmargin / 2; x < width - xmargin / 2; ++x)
        {
            Pixel* p = pic.pixels + width * y + x;
            p->r = p->g = p->b = p->a = 255;
        }
    }

    // canvas border
    int aborder = 64;
    for (int y = 0; y < height; ++y)
    {
        Pixel* p = pic.pixels + width * y + xmargin / 2;
        p->r = p->g = p->b = 0;
        p->a = aborder;

        p = pic.pixels + width * y + (width - xmargin / 2 - 1);
        p->r = p->g = p->b = 0;
        p->a = aborder;
    }
    for (int x = xmargin / 2; x < width - xmargin / 2; ++x)
    {
        Pixel* p = pic.pixels + width * 0 + x;
        p->r = p->g = p->b = 0;
        p->a = aborder;

        p = pic.pixels + width * (height - 1) + x;
        p->r = p->g = p->b = 0;
        p->a = aborder;
    }

    for (int row = 0; row < nrow; ++row)
    {
        int y0 = ymargin + (HChar + ypad) * row;
        if (y0 >= height - ymargin)
            break;

        for (int col = 0; col < ncol; ++col)
        {
            int x0 = xmargin + (WChar + xpad) * col;
            if (x0 >= width - xmargin)
                break;

            char c = text[row * ncol + col];
            for (int y = y0; (y < y0 + HChar) && (y < height - ymargin); ++y)
            {
                for (int x = x0; (x < x0 + WChar) && (x < width - xmargin); ++x)
                {
                    if ((Font[c * HChar + (y - y0)] >> (x - x0)) & 1)
                    {
                        Pixel* p = pic.pixels + width * y + x;
                        p->r = p->g = p->b = 0;
                        p->a = 255;
                    }
                }
            }
        }
    }
}

// take an excerpt from a given file
void excerpt(int nrow, int ncol, char* path, char* text)
{
    // not using 'getline' here, in case 'path' points to a huge file with no linebreaks
    int maxsize = 4096;
    int size = 0;
    char buffer[maxsize + 1];

    FILE* fp = fopen(path, "rb");
    if (fp != NULL)
        size = fread(buffer, sizeof(char), maxsize, fp);
    buffer[size++] = 0;
    fclose(fp);

    for (int i = 0; i < nrow * ncol; ++i)
        text[i] = ' ';

    int row = 0;
    for (int i = 0; (i < size) && (buffer[i] != 0) && (row < nrow);)
    {
        // load first ncol chars from current row
        int col = 0;
        while ((col < ncol) && (buffer[i] != 0) && (buffer[i] != '\n'))
        {
            if (buffer[i] != '\r')
                text[row * ncol + (col++)] = buffer[i++];
            else
                ++i;
        }

        // deplete current row
        while ((col == ncol) && (buffer[i] != 0) && (buffer[i] != '\n'))
            ++i;

        if (buffer[i] == '\n')
        {
            ++row;
            ++i;
        }
        else
            break;
    }
}

// usage: text-thumbnailer input.txt output.png [height]
//
// to flush thumbnail cache:
// rm -rf ~/.cache/thumbnails/*
// rm -rf ~/.thumbnails/*
// killall nautilus
int main(int argc, char* argv[])
{
    if (argc < 3)
        return -1;

    char* input = argv[1];
    char* output = argv[2];

    // somehow nautilus always asks for height 256, even when the display size is 64
    int height = 64; // (argc > 3) ? atoi(argv[3]) : 64;

    int width = height;
    Picture pic = {.width=width, .height=height};
    pic.pixels = calloc(sizeof(Pixel), width * height);

    int nrow = height / HChar + 1;
    int ncol = width / WChar + 1;
    char text[nrow * ncol];
    excerpt(nrow, ncol, input, text);

    draw(pic, text, nrow, ncol);
    save(pic, output);

    free(pic.pixels);
    return 0;
}
