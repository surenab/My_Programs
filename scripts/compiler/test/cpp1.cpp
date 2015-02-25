#include <iostream>
#include <stdio.h>
using namespace std; 
int main()
{
    cout<<"Print the number";
    int n,n1,n2;
    cin>>n;
    n1 = n%10;
    n2 = (n-n1)/10;
    cout<<"First number:  "<<n1<<endl;
    cout<<"Last umber:  "<<n2<<endl;
    if (n2>n1)
    {
        cout<<"n2>n1 \n"<<n2<<endl;cout<<n1<<endl;
    } else {
        cout<<"n2<=n1 \n"<<n1<<endl;cout<<n2<<endl;
    }
    return 1;
}

