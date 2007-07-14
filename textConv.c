#include <stdio.h>
#include <stdlib.h>

static const int fs[64] = {
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2, 3, 3, 3, 3, 3, 1, 2, 3, 1,
    5, 3, 3, 3, 3, 3, 2, 2, 3, 3, 5, 4, 3, 3, 5, 4, 4, 4, 3, 3, 4, 4,
    1, 3, 4, 3, 5, 5, 5, 4, 5, 4, 4, 3, 4, 4, 7, 4, 4, 4, 2, 1
};

static const unsigned char fp[64] = {
    0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 32, 35, 35, 38, 40,
    43, 46, 49, 50, 52, 4, 55, 55, 60, 63, 65, 68, 71, 73, 75, 78,
    78, 33, 83, 86, 89, 94, 98, 102, 106, 109, 112, 116, 94, 120,
    123, 127, 130, 134, 139, 144, 148, 153, 157, 161, 164, 167, 171,
    178, 171, 182, 186, 5
};

static const unsigned char fdata[188] = {
     56,  68,  56,  36, 124,   4,  76,  84,  36,  68,  84,  40,  24,  40, 124, 100,
     84,  88,  56,  84,  72,  76,  80,  96,  40,  84,  40,  36,  84,  56,  44,  28,
    124,  36,  24,  24,  36, 124,  24,  52,  16,  60,  80,  24,  37,  30, 124,  32,
     28, 188,   1, 190, 124,  24,  36,  60,  32,  28,  32,  28,  24,  36,  24,  63,
     36,  24,  36,  63,  60,  16,  32,  52,  44, 120,  36,  56,   4,  60,  56,   4,
     56,   4,  56,  57,   6,  56,  44,  52,  36,  12,  48, 208,  48,  12, 252, 164,
    164,  88, 120, 132, 132,  72, 252, 132, 132, 120, 252, 164, 132, 252, 160, 128,
    120, 132, 164,  56, 252,  32,  32, 252,   8,   4, 248, 252,  48,  80, 140, 252,
      4,   4, 252,  64,  60,  64, 252,  64,  48,   8, 252, 120, 132, 132, 132, 120,
    252, 144, 144,  96, 120, 132, 134, 133, 120, 252, 144, 144, 108,  68, 164, 164,
    152, 128, 252, 128, 248,   4,   4, 248,   4,   8, 240, 224,  28,  16, 224,  28,
     16, 224, 204,  48,  48, 204, 140, 148, 164, 196,   0,   0
};

int main()
{
    char buf[256];
    int lastLine = 0, thisLine;

    while (!feof(stdin))
    {
        int i, j, s;
        fgets(buf, 255, stdin);
        if (feof(stdin))
            break;

        if (buf[0] == '@')
        {
            printf("    !byte 255\n");
            lastLine = 0;
            continue;
        }
        s = 0;
        for (i = 0; buf[i] && buf[i] != 0x0A && buf[i] != 0x0D; i++)
        {
            char *p = buf + i;
            if (*p >= '0' && *p <= '9')
                *p = *p - '0';
            else if (*p >= 'a' && *p <= 'z')
                *p = *p - 'a' + 10;
            else if (*p >= 'A' && *p <= 'Z')
                *p = *p - 'A' + 36;
            else if (*p == ' ')
            {
                *p = 62;
            }
            else if (*p == '.')
            {
                *p = 63;
            }
            else
            {
                printf("invalid char '%c'\n", *p);
                *p = 62;
                continue;
            }
            s += fs[0xFF & (*p)] + 1;
        }
        if (s > 32)
        {
            printf("line too long!\n");
            continue;
        }
        buf[i] = '@';

#if 1
        if( i )
        {
            printf("\n");
            for (j = 0; j < 8; j++)
            {
                int d = 1 << (7 - j);
                printf("    ;");
                for (i = 0; buf[i] != '@'; i++)
                {
                    int t = fs[0xFF & buf[i]];
                    int p = fp[0xFF & buf[i]];
                    while (t--)
                    {
                        if (fdata[p] & d)
                            printf("@@");
                        else
                            printf("  ");
                        p++;
                    }
                    printf(" ");
                }
                printf("\n");
            }
        }
#endif

        thisLine = (32 - s) / 2;
        i        = 0;
        if (lastLine + thisLine > 0)
            printf("    !byte (128+%d)", lastLine + thisLine - 1);
        else
        {
            if (buf[0] != '@')
            {
                printf("    !byte       %d", buf[0]);
                i++;
            }
        }

        for (; buf[i] != '@'; i++)
            printf(", %d", buf[i]);
        printf("\n");

        // pixels extra from last line
        lastLine = 32 - s - thisLine;
    }
    return 0;
}
