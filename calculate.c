#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    FILE *fp = fopen("orig.txt", "r");
    FILE *output = fopen("output.txt", "w");
    if (!fp) {
        printf("ERROR opening input file orig.txt\n");
        exit(0);
    }
    char append[50], find[50];
    double orig_sum_a = 0.0, orig_sum_f = 0.0, orig_a, orig_f;
    for (int i = 0; i < 100; i++) {
        if (feof(fp)) {
            printf("ERROR: You need 100 datum instead of %d\n", i);
            printf("run 'make run' longer to get enough information\n\n");
            exit(0);
        }
        fscanf(fp, "%s %s %lf %lf\n", append, find,&orig_a, &orig_f);
        orig_sum_a += orig_a;
        orig_sum_f += orig_f;
    }
    fclose(fp);

    fp = fopen("row.txt", "r");
    if (!fp) {
        fp = fopen("orig.txt", "r");
        if (!fp) {
            printf("ERROR opening input file row.txt\n");
            exit(0);
        }
    }
    double row_sum_a = 0.0, row_sum_f = 0.0, row_a, row_f;
    for (int i = 0; i < 100; i++) {
        if (feof(fp)) {
            printf("ERROR: You need 100 datum instead of %d\n", i);
            printf("run 'make run' longer to get enough information\n\n");
            exit(0);
        }
        fscanf(fp, "%s %s %lf %lf\n", append, find,&row_a, &row_f);
        row_sum_a += row_a;
        row_sum_f += row_f;
    }


    fp = fopen("col.txt", "r");
    if (!fp) {
        fp = fopen("orig.txt", "r");
        if (!fp) {
            printf("ERROR opening input file col.txt\n");
            exit(0);
        }
    }
    double col_sum_a = 0.0, col_sum_f = 0.0, col_a, col_f;
    for (int i = 0; i < 100; i++) {
        if (feof(fp)) {
            printf("ERROR: You need 100 datum instead of %d\n", i);
            printf("run 'make run' longer to get enough information\n\n");
            exit(0);
        }
        fscanf(fp, "%s %s %lf %lf\n", append, find,&col_a, &col_f);
        col_sum_a += col_a;
        col_sum_f += col_f;
    }

    fprintf(output, "append() %lf %lf %lf\n", orig_sum_a / 100.0,
            row_sum_a / 100.0,col_sum_a / 100.0);
    fprintf(output, "findName() %lf %lf %lf\n", orig_sum_f / 100.0,
            row_sum_f / 100.0,col_sum_f / 100.0);
    fprintf(output, "Total %lf %lf %lf", (orig_sum_f+orig_sum_a) / 100.0,
            (row_sum_f+row_sum_a) / 100.0,(col_sum_f+col_sum_a) / 100.0);
    fclose(output);
    fclose(fp);
    return 0;
}
