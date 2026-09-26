q := 'Hello, world!';
r := '';
s := 'a'; ss := 'b';


t := 'it''s a test';
u := '''';
v := '''quoted''';


w := #77;
x := #13#10;
pp := #$41;
rr := #&101;
ss := #%1000001;

sss := #%1010121;
sss := #&1284;
sss := #$2g;
sss := #123a4;

sss := #$;
sss := #&x;
sss := #%z;

y := 'Tab:'#9'End';
z := 'Line1'#13#10'Line2';
zz := 'a'#62'b'; #33#33


zzz := 'a' #62 'b';

// Caret-нотация
kk := ^Z;
kkk := ^ZZ; // >1 символа


aa := 'contains // not a comment';
bb := 'contains { not a comment }';
cc := 'contains (* not a comment *)';
dd := '42 and 3.14';


ff := #300;
gg := #abc;
q  := 'abc