# Assignment 2
## Q1
- winter > summer
- "equal billing plan"
  - pay same amount every month
  - "true-up month" is every 6 months
- "True-up month"
  - If customer owes more than monthly amount:
    -  customer pays entire outstanding balance 
    -  billing cycle starts over
  - Else:
    - Company does not refund money
    - If overpaid balance > monthly amount:
      - Charge 0 for the month
      - reduce overpaid balance by one monthly amount
    - If overpaid > 0 and overpaid < monthly amount:
      - company charges balance - monthly rate
  - New monthly rate calculated for next billing cycle
    - Avg monthly use since last true-up month (rounded down + 1)

Program Parameters;
- initial month billing amount

Program Input:
- Sequence of monthly amounts used (starts with month 1)


Output:
- Amount of monthly bill/month


More notes:
- EOF ends program

### Case 1 (Same amount/month):
```bash
# Case 1a - same nums
$ ./gas 10
8 You pay: 10  (Usage: 8  Paid: 10  Balance: 0)
8 You pay: 10  (Usage: 16  Paid: 20  Balance: 0)
8 You pay: 10  (Usage: 24  Paid: 30  Balance: 0)
8 You pay: 10  (Usage: 32  Paid: 40  Balance: 0)
8 You pay: 10  (Usage: 40  Paid: 50  Balance: 0)
```
```bash
# Case 1b - diff nums
$ ./gas 10
8 You pay: 10  (Usage: 8  Paid: 10  Balance: 0)
2 You pay: 10  (Usage: 10  Paid: 20  Balance: 0)
3 You pay: 10  (Usage: 13  Paid: 30  Balance: 0)
5 You pay: 10  (Usage: 18  Paid: 40  Balance: 0)
0 You pay: 10  (Usage: 18  Paid: 50  Balance: 0)
```

### Case 2  (6 .in sequence (1 truth month)):
```bash
# Case 2a - If customer > balance
$./gas 10
8 You pay: 10  (Usage: 8  Paid: 10  Balance: 0)
8 You pay: 10  (Usage: 16  Paid: 20  Balance: 0)
8 You pay: 10  (Usage: 24  Paid: 30  Balance: 0)
8 You pay: 10  (Usage: 32  Paid: 40  Balance: 0)
8 You pay: 10  (Usage: 40  Paid: 50  Balance: 0)
8 You pay: 0  (Usage: 48  Paid: 0  Balance: 2)
  Rate Now: 9
8 You pay: 7  (Usage: 8  Paid: 7  Balance: 0)
```

```bash
# Case 2b - If customer < balance
$./gas 10
8 You pay: 10  (Usage: 8  Paid: 10  Balance: 0)
10 You pay: 10  (Usage: 18  Paid: 20  Balance: 0)
22 You pay: 10  (Usage: 40  Paid: 30  Balance: 0)
1 You pay: 10  (Usage: 41  Paid: 40  Balance: 0)
1 You pay: 10  (Usage: 42  Paid: 50  Balance: 0)
32 You pay: 24  (Usage: 74  Paid: 0  Balance: 0)
  Rate Now: 13
10 You pay: 13 (Usage: 10  Paid: 13  Balance: 0)
1 You pay: 13 (Usage: 11  Paid: 13  Balance: 0)
```

```bash
# Case 2c - If customer == balance
$./gas 10
10 You pay: 10  (Usage: 10 Paid: 10  Balance: 0)
10 You pay: 10  (Usage: 20  Paid: 20  Balance: 0)
10 You pay: 10  (Usage: 30  Paid: 30  Balance: 0)
10 You pay: 10  (Usage: 40  Paid: 40  Balance: 0)
10 You pay: 10  (Usage: 50  Paid: 50  Balance: 0)
10 You pay: 10 (Usage: 60 Paid: 0 Balance: 0)
  Rate Now: 11
10 You pay: 11 (Usage: 10 Paid: 11 Balance: 0)
10 You pay: 11 (Usage: 20 Paid: 22 Balance: 0)
2 You pay: 11 (Usage: 22 Paid: 33 Balance: 0)
30 You pay: 11 (Usage: 52 Paid: 44 Balance: 0)
40 You pay: 11 (Usage: 92 Paid: 55 Balance: 0)
20 You pay: 57 (Usage: 112 Paid: 0 Balance: 0)
  Rate Now: 19
```

```bash
# Case 2d - Dipping into balance
$ ./a2q1 20
20 You pay: 20  (Usage: 20  Paid: 20  Balance: 0)
30 You pay: 20  (Usage: 50  Paid: 40  Balance: 0)
20 You pay: 20  (Usage: 70  Paid: 60  Balance: 0)
10 You pay: 20  (Usage: 80  Paid: 80  Balance: 0)
20 You pay: 20  (Usage: 100  Paid: 100  Balance: 0)
30 You pay: 30  (Usage: 130  Paid: 0  Balance: 0)
Rate now 22
20 You pay: 22  (Usage: 20  Paid: 22  Balance: 0)
1 You pay: 22  (Usage: 21  Paid: 44  Balance: 0)
1 You pay: 22  (Usage: 22  Paid: 66  Balance: 0)
1 You pay: 22  (Usage: 23  Paid: 88  Balance: 0)
1 You pay: 22  (Usage: 24  Paid: 110  Balance: 0)
1 You pay: 0  (Usage: 25  Paid: 0  Balance: 85)
Rate now 5
20 You pay: 0  (Usage: 20  Paid: 0  Balance: 80)
30 You pay: 0  (Usage: 50  Paid: 0  Balance: 75)
40 You pay: 0  (Usage: 90  Paid: 0  Balance: 70)
20 You pay: 0  (Usage: 110  Paid: 0  Balance: 65)
30 You pay: 0  (Usage: 140  Paid: 0  Balance: 60)
90 You pay: 145  (Usage: 230  Paid: 0  Balance: 0)
Rate now 39
20 You pay: 39  (Usage: 20  Paid: 39  Balance: 0)
20 You pay: 39  (Usage: 40  Paid: 78  Balance: 0)
10 You pay: 39  (Usage: 50  Paid: 117  Balance: 0)
30 You pay: 39  (Usage: 80  Paid: 156  Balance: 0)
20 You pay: 39  (Usage: 100  Paid: 195  Balance: 0)
40 You pay: 0  (Usage: 140  Paid: 0  Balance: 55)
Rate now 24
```

```bash
$ ./a2q1 20
3 You pay: 20  (Usage: 3  Paid: 20  Balance: 0)
2 You pay: 20  (Usage: 5  Paid: 40  Balance: 0)
5 You pay: 20  (Usage: 10  Paid: 60  Balance: 0)
12 You pay: 20  (Usage: 22  Paid: 80  Balance: 0)
32 You pay: 20  (Usage: 54  Paid: 100  Balance: 0)
4 You pay: 0  (Usage: 58  Paid: 0  Balance: 42)
Rate now 10
2 You pay: 0  (Usage: 2  Paid: 0  Balance: 32)
2 You pay: 0  (Usage: 4  Paid: 0  Balance: 22)
21 You pay: 0  (Usage: 25  Paid: 0  Balance: 12)
3 You pay: 0  (Usage: 28  Paid: 0  Balance: 2)
2 You pay: 8  (Usage: 30  Paid: 8  Balance: 0)
40 You pay: 20  (Usage: 70  Paid: 0  Balance: 0)
Rate now 12
2 You pay: 12  (Usage: 2  Paid: 12  Balance: 0)

```
### Boundary Cases
```bash
# Test boundary args case
$ ./gas 0
8 You pay: 0  (Usage: 8  Paid: 0  Balance: 0)
1 You pay: 0  (Usage: 9  Paid: 0  Balance: 0)
```

### Missing File Cases
```bash
# Test Missing .args
$ ./gas 
Incorrect usage, ./a2q1 expect 1 arguments, recieved 0 instead.
```

```bash
# Test too many .args
$ ./gas 2 3
Incorrect usage, ./a2q1 expect 1 arguments, recieved 2 instead.
```

### Negative Argument
```bash
./a2q1 -3
10
You pay: 0  (Usage: 10  Paid: 0  Balance: 3)
30
You pay: 0  (Usage: 40  Paid: 0  Balance: 6)
20
You pay: 0  (Usage: 60  Paid: 0  Balance: 9)
40
You pay: 0  (Usage: 100  Paid: 0  Balance: 12)
20
You pay: 0  (Usage: 120  Paid: 0  Balance: 15)
30
You pay: 150  (Usage: 150  Paid: 0  Balance: 0)
Rate now 26
20
You pay: 26  (Usage: 20  Paid: 26  Balance: 0)
```

```bash
./a2q1 -10
1
You pay: 0  (Usage: 1  Paid: 0  Balance: 10)
2
You pay: 0  (Usage: 3  Paid: 0  Balance: 20)
1
You pay: 0  (Usage: 4  Paid: 0  Balance: 30)
3
You pay: 0  (Usage: 7  Paid: 0  Balance: 40)
2
You pay: 0  (Usage: 9  Paid: 0  Balance: 50)
1
You pay: 10  (Usage: 10  Paid: 0  Balance: 0)
Rate now 2
2
You pay: 2  (Usage: 2  Paid: 2  Balance: 0)
1
You pay: 2  (Usage: 3  Paid: 4  Balance: 0)
4
You pay: 2  (Usage: 7  Paid: 6  Balance: 0)
2
You pay: 2  (Usage: 9  Paid: 8  Balance: 0)
5
You pay: 2  (Usage: 14  Paid: 10  Balance: 0)
3
You pay: 7  (Usage: 17  Paid: 0  Balance: 0)
Rate now 3
6
You pay: 3  (Usage: 6  Paid: 3  Balance: 0)
2
You pay: 3  (Usage: 8  Paid: 6  Balance: 0)
3
You pay: 3  (Usage: 11  Paid: 9  Balance: 0)
```

### Negative Input
```bash
./a2q1 0
-2
You pay: 0  (Usage: -2  Paid: 0  Balance: 0)
-4
You pay: 0  (Usage: -6  Paid: 0  Balance: 0)
-2
You pay: 0  (Usage: -8  Paid: 0  Balance: 0)
-5
You pay: 0  (Usage: -13  Paid: 0  Balance: 0)
3
You pay: 0  (Usage: -10  Paid: 0  Balance: 0)
-6
You pay: 0  (Usage: -16  Paid: 0  Balance: 16)
Rate now -1
-5
You pay: 0  (Usage: -5  Paid: 0  Balance: 17)
2
You pay: 0  (Usage: -3  Paid: 0  Balance: 18)
-3
You pay: 0  (Usage: -6  Paid: 0  Balance: 19)
6 
You pay: 0  (Usage: 0  Paid: 0  Balance: 20)
-4
You pay: 0  (Usage: -4  Paid: 0  Balance: 21)
0
You pay: 0  (Usage: -4  Paid: 0  Balance: 20)
Rate now 1
-100
You pay: 0  (Usage: -100  Paid: 0  Balance: 19)
2 
You pay: 0  (Usage: -98  Paid: 0  Balance: 18)
3
You pay: 0  (Usage: -95  Paid: 0  Balance: 17)
5
You pay: 0  (Usage: -90  Paid: 0  Balance: 16)
6
You pay: 0  (Usage: -84  Paid: 0  Balance: 15)
2
You pay: 0  (Usage: -82  Paid: 0  Balance: 102)
Rate now -12
```

# Test Negative In and Args
```bash
./a2q1 -3
-4
You pay: 0  (Usage: -4  Paid: 0  Balance: 3)
0
You pay: 0  (Usage: -4  Paid: 0  Balance: 6)
9
You pay: 0  (Usage: 5  Paid: 0  Balance: 9)
-3
You pay: 0  (Usage: 2  Paid: 0  Balance: 12)
-2
You pay: 0  (Usage: 0  Paid: 0  Balance: 15)
102
You pay: 102  (Usage: 102  Paid: 0  Balance: 0)
Rate now 18
-0
You pay: 18  (Usage: 0  Paid: 18  Balance: 0)
-3
You pay: 18  (Usage: -3  Paid: 36  Balance: 0)
-4
You pay: 18  (Usage: -7  Paid: 54  Balance: 0)
02
You pay: 18  (Usage: -5  Paid: 72  Balance: 0)
-3
You pay: 18  (Usage: -8  Paid: 90  Balance: 0)
22
You pay: 0  (Usage: 14  Paid: 0  Balance: 76)
Rate now 3
3
You pay: 0  (Usage: 3  Paid: 0  Balance: 73)
5
You pay: 0  (Usage: 8  Paid: 0  Balance: 70)
-3
You pay: 0  (Usage: 5  Paid: 0  Balance: 67)
-9
You pay: 0  (Usage: -4  Paid: 0  Balance: 64)
3
You pay: 0  (Usage: -1  Paid: 0  Balance: 61)
```
# Test Missing .in
```bash
# Testing Missing .in
$ ./gas 3

Error no .in
```

### Error Cases
```bash
# Test Error .args case (string)
$ ./gas hi
Error
```

```bash
# Test Error .in case (string)
$ ./gas 2
hi 
Error
```

## Q2
- Encryption
  - Each letter in text replaced by a letter some fixed # of positions down/up alphabet
  - ONLY UPPER OR LOWER CASE ENGLISH ALPHABET
  - any other char will be left unchanged in output
- Decryption - reverse of encryption

**Arguments (0, 1, 2 args):**
- 0 Arguments:  
  - shifts **3 to the right**
- 1 argument (shift value)
  - Int value
  - 0 <= x <= 25
- 2 arguments:
  - string
  - "left"
  - "right"
 
**Input**
- Each line begins with 'e', 'd', 'q'
- encryption, decryption, quit

### Case 1: 0 arguments
```bash
# All lowercase
elaura
>> odxud

dlaura
>> ixrox

dded
>> aba

eded
>> ghg

eeded
>> hghg

deded
>> baba

eLAURA
>> ODXUD

dLAURA 
>> IXROX

eLauraDang
>> OdxudGdqj

dLauraDang
>> IxroxAxkd

e@$/%
>> @$/%

d@$?@&#
>> @$?@&#

eL@ur$A
>> O@xu$D

dL@urzA
>> I@rowX
```

### Case 2: 1 argument
```bash
Arg: 0
dlaura
>> laura
elaura
>> laura
dLAURA
>> LAURA
eLAURA
>> LAURA
dLauraDang
>> LauraDang
eLauraDang
>> LauraDang
d*$(#LAJKF
>> *$(#LAJKF
e()(?1
>> ()(?1
```

```bash
Arg: 13
dlaura
>> ynhen
elaura
>> ynhen
dLAURA
>> YNHEN
dLauraDang
>> YnhenQnat
d$%^&*&jfkdlsjf
>> $%^&*&wsxqyfws
e%^&U4382904832fjkdsljfdkls
>> %^&H4382904832swxqfywsqxyf
d(((99
>> (((99
eHELLOZYZHFA
>> URYYBMLMUSN
deHELLOZYZHFA
>> rURYYBMLMUSN
```

```bash
Arg: 25
dlaura
>> mbvsb
dLAURA
>> MBVSB
dLauraDang
>> MbvsbEboh
elaura
>> kztqz
eLAURA
>> KZTQZ
eLauraDang
>> KztqzCzmf
e3456789ojfdsfa
>> 3456789niecrez
d849302849302jfkdlsjafdks
>> 849302849302kglemtkbgelt
ejkdslajfkdsla943290432
>> ijcrkziejcrkz943290432
dfjdaskljdskalfds920194
>> gkebtlmketlbmget920194
dddddddd
>> eeeeeee
eeeeeeeeeee
>> dddddddddd
eEEEEEEee     
>> DDDDDDdd
dEEEeeEEE?
>> FFFffFFF?
```

```bash
Arg: 25
dlaura
>> mbvsb
dLAURA
>> MBVSB
dLauraDang
>> MbvsbEboh
elaura
>> kztqz
eLAURA
>> KZTQZ
eLauraDang
>> KztqzCzmf
e3456789ojfdsfa
>> 3456789niecrez
d849302849302jfkdlsjafdks
>> 849302849302kglemtkbgelt
ejkdslajfkdsla943290432
>> ijcrkziejcrkz943290432
dfjdaskljdskalfds920194
>> gkebtlmketlbmget920194
dddddddd
>> eeeeeee
eeeeeeeeeee
>> dddddddddd
eEEEEEEee     
>> DDDDDDdd
dEEEeeEEE?
>> FFFffFFF?
```

```bash
Arg: 0 left
dlaura
>> laura
elaura
>> laura
dded
>> ded
dEEEDDED
>> EEEDDED
eEEEDED
>> EEEDED
e^&*#JFDJSKLFD
>> ^&*#JFDJSKLFD
d*(*()JJLK43892
>> *(*()JJLK43892
```

```bash
Arg: 0 right
dLAURA
>> LAURA
eLAURA
>> LAURA
dlaura
>> laura
elaura
>> laura
dJFDKSLFJDSjfdskljfds
>> JFDKSLFJDSjfdskljfds
eHFDJKGHfhdkjsjfds
>> HFDJKGHfhdkjsjfds
d34567876fdsjfkldsjkl^&(*
>> 34567876fdsjfkldsjkl^&(*
d78978493274328()*!
>> 78978493274328()*!
e53758943][][
>> 53758943][][
```

```bash
Arg: 6 left
dlaura
>> rgaxg
elaura
>> fuolu
dLAURA
>> RGAXG
eLAURA
>> FUOLU
ddddddd
>> jjjjjj
eeeeeee
>> yyyyyy
eEEEEE
>> YYYYY
dDDDdd
>> JJJjj
eEEEddjfkdlsfjdks
>> YYYxxdzexfmzdxem
e4738294JFKDLSJFKDLS483920?><
>> 4738294DZEXFMDZEXFM483920?><
d5678935342543?>?>fds{}{}
>> 5678935342543?>?>ljy{}{}
eeeeeeee*()*()*(
>> yyyyyyy*()*()*(
eAFDSFDSAAA
>> UZXMZXMUUU
eABABABABAB
>> UVUVUVUVUV
dABABABAB
>> GHGHGHGH
```

```bash
Arg: 6 right
dlaura
>> rgaxg
elaura
>> fuolu
dLAURA
>> RGAXG
eLAURA
>> FUOLU
ddddddd
>> jjjjjj
eeeeeee
>> yyyyyy
eEEEEE
>> YYYYY
dDDDdd
>> JJJjj
eEEEddjfkdlsfjdks
>> YYYxxdzexfmzdxem
e4738294JFKDLSJFKDLS483920?><
>> 4738294DZEXFMDZEXFM483920?><
d5678935342543?>?>fds{}{}
>> 5678935342543?>?>ljy{}{}
eeeeeeee*()*()*(
>> yyyyyyy*()*()*(
eAFDSFDSAAA
>> UZXMZXMUUU
eABABABABAB
>> UVUVUVUVUV
dABABABAB
>> GHGHGHGH
```

```bash
Args: 6 right
dlaura
>> fuolu
dLAURA
>> FUOLU
dddED
>> xxYX
ddddddd
>> xxxxxx
eeeeeee
>> kkkkkk
eLAURA
>> RGAXG
e@*($)%LAUF*F&DS
>> @*($)%RGAL*L&JY
dJFKDLS((FDS
>> DZEXFM((ZXM
dJFKDLS((FDS
>> DZEXFM((ZXM
dZZZEZ
>> TTTYT
dZEZEZEZ
>> TYTYTYT
eZEZEZEZ
>> FKFKFKF
```

```bash
Args: 25 left

dlaura
>> kztqz
dLAURA
>> KZTQZ
elaura
>> mbvsb
eLAURA
>> MBVSB
dLauraDang
>> KztqzCzmf
eLauraDang
>> MbvsbEboh
d@$*()*%432
>> @$*()*%432
e*$(#)*8390432
>> *$(#)*8390432
dAAAAAAAA
>> ZZZZZZZZ
eZZZZZZZ
>> AAAAAAA
dY&Y&Y&YY 
>> X&X&X&XX
e(I(I(I(I
>> (J(J(J(J
```

```bash
Args: 25 right

dlaura
>> mbvsb
dLAURA
>> MBVSB
elaura
>> kztqz
eLAURA
>> KZTQZ
dLauraDang
>> MbvsbEboh
eLauraDang
>> KztqzCzmf
d^*&(&*(SDHJKSDFHJKhdfsjkdfhjks*(&&*(*(&
>> ^*&(&*(TEIKLTEGIKLiegtklegiklt*(&&*(*(&
e*&((*&*(hjkjkhkjhJHKJKHHJKfds897978897
>> *&((*&*(gijijgjigIGJIJGGIJecr897978897
df*f*f*
>> g*g*g*
ddddddd
>> eeeeee
dDdDdDdD
>> EeEeEeE
eEeEeEE
>> DdDdDD
eeeeee
>> ddddd
dqqq
>> rrr
dDEEEEAAAD 
>> EFFFFBBBE
```

## Error testing

### ./
```bash
Args: ./a2q2 fdsjkl
>> ERROR: first argument must be an int 

Args: ./a2q2 left
>> ERROR: first argument must be an int value

Args: ./a2q2 *895
>> ERROR: first argument must be an int value

Args: ./a2q2 8494k
>> ERROR: Incorrect shift value

Args: ./a2q2 -1
>> ERROR: Incorrect shift value

Args: ./a2q2 26
>> ERROR: Incorrect shift value

Args: ./a2q2 26 left
>> ERROR: Incorrect shift value

Args: ./a2q2 26 right
>> ERROR: Incorrect shift value

Args: ./a2q2 -1 left
>> ERROR: Incorrect shift value

Args: ./a2q2 -1 right
>> ERROR: Incorrect shift value

Args: ./a2q2 -1 top
>> ERROR: Incorrect shift value

Args: ./a2q2 20 rightl
>> ERROR: Incorrect direction (only left or right allowed).

Args: ./a2q2 20 right!
>> ERROR: Incorrect direction (only left or right allowed).

Args: ./a2q2 20 left right
>> ERROR: program should not be called with more than 2 arguments

./a2q2 20 LEFT
>> ERROR: Incorrect direction (only left or right allowed).

./a2q2 20 RIGHT
>> ERROR: Incorrect direction (only left or right allowed).

./a2q2 20 Left
>> ERROR: Incorrect direction (only left or right allowed).

./a2q2 20 Right
>> ERROR: Incorrect direction (only left or right allowed).
```

# Q3
- program name: **wordWrap**
- confines text to given width with desired justification
- echos stdin s.t. width of output is not wider than argument
- output is left justified, centered, or right justified


**Arguments**: 
- 1. optional -w width argument (desired width) - positive integer
- 2. optional -l, -c, or -r (left justified, centered, right justified)
- If no width supplied: default is 25
- If no second argument supplied, default is left justified

**Input**: sequence of tokens

- ignore \n when considering text width
- do not print trailing spaces after last non-whitespace char of each line
- If there is odd # of spaces to distribute, put extra space on right
- if word is too long than allowed width => put it on next line (don't break it unless it is longer than entire allowed width)
- Separate words by a single whitespace char (either a space or \n) - even if input had words separated by 2 spaces, be separated by 1 whitespace char in output
**Assumptions**:
- if width arg is provided => positive int
- at most 1 justification style option will be given by user


# Test
### No Args
```bash
# < 25 chars
ahahahahahah
```

# Q5

```C++
struct BinaryNum {
    int size;
    int capacity;
    bool *contents;
// number of elements the array currently holds
// number of elements the array could hold,
// given current memory allocation to contents
// (pointer to) heap-allocated array of bools
};

```
## readBinaryNum
- returns BinaryNum struct
- consumes 1s and 0s from cin
- populates struct with these and then returns the struct

If char != whitespace and char != 0 or 1:
  - function fills as much of array as needed, leaving rest unfilled

If char != 0 or 1: 
  - first offending char is removed from input stream

In all circumstances:
- field ```size``` represents # of elements stored in array 
- field ```capacity``` represents storage currently allocated to array

## binaryConcat
- takes BinaryNum struct
- concatenates as many bools from cin onto the end of the struct
- behaviour same as readBinaryNum except integers are added to end of existing binaryNum

## binaryToDecimal
- takes BinaryNum struct BY REFERNCE TO CONST
- returns int 
  - returns decimal value equivalent of binary number represented in BinaryNum
- undefined if decimal equivalent of bin number > INT_MAX

## printBinaryNum
- takes BinaryNum struct BY REFERENCE TO CONST
- takes separator char
- prints contents of binNum to stream out:
  - on the same line
  - separated by chars in sep
  - ends with \n
  - no separator before first element
  - no separator after last element

## operator
- takes left hand operand BinaryNum struct by reference
- takes right hand operand int
- returns reference to same BinaryNum struct passed from argument
- moves bit in binNum x places to the left adding appropriate # of 0s onto the end of the #


## Memory allocation:
- Every struct begins with capacity 0
- First time data is stored in struct:
  - has capcity 4 and space allocated accordingly
  - if not enough, you must double capacity

```bash
int main() {
    const int arr_size = 4;
    BinaryNum a[arr_size];
    
    # fill array with null
    for (int i = 0; i < arr_size; ++i) {
	    a[i].contents = nullptr;
    }

    bool done = false;
    while (!done) {
        char c;
        char which;
        cin >> c; # reads r, +, d, p, s or q
        
        if (cin.eof()) break;
        switch(c) {
            case 'r':
                cin >> which; # reads a b c or d
                delete[] a[which-'a'].contents;
                a[which-'a'].contents = nullptr;
                a[which-'a'] = readBinaryNum();
                break;
            case '+':
                cin >> which; # reads a b c or d
                binaryConcat(a[which-'a']);
                break;
            case 'p':
                cin >> which; # reads a b c or d
                char sep;
                cin >> sep; # reads one char for sep char.
                printBinaryNum(cout, a[which-'a'],sep);
                cout << endl;
                break;
            case 'd':
                cin >> which; # reads a b c or d
                cout << binaryToDecimal(a[which-'a']) << endl;
                break;
            case 's':
                cin >> which; # reads a b c or d
                int x;
                cin >> x; # reads how much to shift by.
                a[which-'a'] << x;
                break;
            case 'q':
                done = true;
                break;
        }
    }
    for (int i = 0; i < arr_size; ++i) {
	    delete[] a[i].contents;
    }
}
```