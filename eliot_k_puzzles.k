/ Problem 1 - Joins 1
/ This is the solution I came up with on my own:
f:{x,' y}
g:{f[;y]' x}

/ sample run:
a:0 1 2 
b:`jim `derek `brian `peter `ryan `don
g[a;b]

/ timed run
\t do[10000;g[a;b]] 

/ after reviewing with Brian, I now know that I can simplify my solution 
/ to look like this: a,/:\:b

/ Problem 2 - Joins 2
/ My solution:
g:{(,/ ,/:\:)/ x}

/ sample run:
a:("/-\\|/";"ab";"01")
g[a]

/ timed run:
\t do[10000;g[a]] 

/ Problem 3 - Get Cutpoints 
/ My solution:
getCutpoints:{-1 _ 0 +\ #:'x}

/ sample run:
a~getCutpoints[a]_,/a:(234 45 2 0; 2 3;,1;99 9 9 9 9 ;!0)

/ timed run:
\t do[10000;getCutpoints[a]] 

/ Problem 4 - Frequency
/ My solution:
f:{(0,(& (x) = ",")) _ (x)} / a helper function, f

g:{
q: (x; (1 _ x))
q[x[0]~","]} / helper function, g

h:{y[x[0]],#x} / helper function, h

freq:{
	b: `$g' ,/ f'x
	h[;b]' = b} / main function to get the frequency of each item

finish:{
x:x@<x
if[(x . 0 0)~`;x:(1 _ x)]
x}	/ called at the end to handle sorting and final formatting

/ sample run:
a:0:"names.txt"  / change your filename/filepath accordingly
finish[freq[a]]

/ timed run:
\t do[10000;finish[freq[a]]]

/ Problem 5 - Digit Summation
/ My solution:
reset:{
.k.c:0
.k.count:($1)
.k.counter:1
}
g:{
.k.count[.k.counter - 1]:x
.k.count,:($1)
.k.c:0
.k.counter:1
}
h:{
.k.count[.k.counter - 1]:x
.k.counter:1
}
i:{
.k.count[.k.counter - 1]:x
.k.counter+:1
}
pow:{
n:.k.c+(0$x)*2
.k.c:0
if[n > 9; .k.c:1; n:n-10]
:[((#.k.count)=.k.counter)&(.k.c=1); g[$n];(#.k.count)=.k.counter; h[$n];i[$n]]
}

run:{x;pow' .k.count}

xrun:{
reset[]
run' (x # 1)
.k.count}  / this will return the actual value of 2^x, as a list of chars
/ a simple expression can be run, as shown in the sample run, to get
/ the actual sum of the digits

/ sample run:  
+/ 0$' xrun[1000]

/ timed run: 
\t do[10;+/ 0$' xrun[1000]] / I'm running this one only 10 times because
/ frankly it's very slow (about 300ms for a single run). Unfortunately,
/ I'm not sure how that actually compares to an optimized solution.
/ I would definitely be interested to see a more optimized solution,
/ along with the run time of that solution. 

/ Problem 6 - Josephus Problem
/ my solution:
j:{-1_ *:'(y!1_)\ y!z!!x} 

/ after reviewing this one with David, I realized that it was actually very
/ close to the "official" solution, but that there are two improvements that 
/ make the official solution slightly faster.
/ the first improvement is that [;0] is faster than *:'
/ the second improvement is that the official solution runs (x-1) times
/ where mine runs x times and drops the last item off the list at the end.
/ so, I learned that by using the n f\ x form of scan, I can save an unnecessary
/ call in situations like this one.

/ sample run:
j[10;2;5]

/ timed run:
\t do[10000;j[10;2;5]]

/ Problem 7 - Unique
/ my solution:
u:{:[2>#?x[;0];?x;' `InvalidType]}

/ sample run:
a: ((3;`hello);(3;`world);(3;`hello);(3;`again))
b: ((3;`hello);(3;`world);(3;`hello);(4;`woops);(3;`again))
u[a]
/ the line below throws the InvalidType error, as expected
/ I've commented it out so that the program can run uninterrupted
/ u[b]

/ timed run:
\t do[10000;u[a]]

/ Problem 8 - Hierarchical Query 1
/ initialize dictionary:
h:.+(`n`p;(`$'_ci 65+!26;0 0 0 0 1 1 1 2 3 3 3 3 3 4 5 6 13 16 16 16 16 0 21 21 21 7))

/ my solution:
f:{h.n@x,(h.p@)\ h.p[x]} 

/ David showed me that this can be significantly simplified to h.n(h.p\7)
/ I didn't realize at the time that that sort of syntax was valid, so we reviewed
/ some of the options k offers in this regard, which was very helpful. 

/ sample run:
f[7]

/ timed run:
\t do[10000;f[7]]

/ Problem 9 - Hierarchical Query 2
/ my solution:

f:{h.n@x,(h.p@)\ h.p[x]} / this is the function I created for problem #8
/ so, right off the bat, I know that this function could be optimized if I used
/ the better solution for problem 8.
a:f'h.p
b:#:'a
c:a@&(|/b)~'b / I understood the directions to mean that I should return
/ all of the longest strings in the event of a tie, even if those strings were identical

/ sample output: 
c

/ timed run
\t do[10000;{a:f'h.p;b:#:'a;a@&(|/b)~'b}[]]

/ Problem 10 - Rolemap and Security Calculation

users:.+(`username`memberOfGroups
(`optimus_prime`megatron`soundwave`brawn`bumblebee`frenzy`laserbeak`jazz`ironhide`mirage`prowl`wheeljack`starscream
(1 5 6
 5 6 7
 2 4 6
 2 4 5 7
 0 2 5 6
 6 7
 ,6
 2 5 6
 0 5 6 7
 2 5 6 7
 1 4 6 7
 0 4 6 7
 6 7)))  / initializing the users dictionary

rolemap:.+(,`viewers;,.+(`users`groups;(`wheeljack`jazz`mirage;2 3 5))) /initializing a rolemap to check permissions against

/ My Solution:

cv:{
:[(#y.viewers.users)>y.viewers.users?x; :1;(#y.viewers.groups)>&/y.viewers.groups?/:users.memberOfGroups@users.username?x;:1;0]}
 
canUsersView:{
cv[;y]' x}

/ sample run:
canUsersView[`frenzy`wheeljack`brawn`jazz`starscream`soundwave;rolemap]

/ timed run:
\t do[10000;canUsersView[`frenzy`wheeljack`brawn`jazz`starscream`soundwave;rolemap]]