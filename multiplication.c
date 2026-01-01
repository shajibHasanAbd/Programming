#include <stdio.h>
int main(){

    int num, sum=0 ;

    printf("enter the number : ");
    scanf("%d",&num );

    for(int i=1; i <= 10 ;i++){

      printf("%d x %d = %d\n",i, num, i*num); //1 x 5 = 5
                                            //2 x 5 = 10
    }

    return 0;
}
