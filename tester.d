// dfmt off
T lread(T=long)(){return readln.chomp.to!T;}T[] lreads(T=long)(long n){return iota(n).map!((_)=>lread!T).array;}
T[] aryread(T=long)(){return readln.split.to!(T[]);}void arywrite(T)(T a){a.map!text.join(' ').writeln;}
void scan(L...)(ref L A){auto l=readln.split;foreach(i,T;L){A[i]=l[i].to!T;}}alias sread=()=>readln.chomp();
void dprint(L...)(lazy L A){debug{auto l=new string[](L.length);static foreach(i,a;A)l[i]=a.text;arywrite(l);}}
static immutable MOD=10^^9+7;alias PQueue(T,alias l="b<a")=BinaryHeap!(Array!T,l);import std;
// dfmt on

void main()
{
    // sread().writeln();
    long D = lread();
    auto C = aryread();
    auto S = new long[][](D);
    foreach (i; 0 .. D)
    {
        S[i] = aryread();
    }
    auto T = new long[](D);
    foreach (i; 0 .. D)
    {
        T[i] = lread();
    }
    T[] -= 1;

    long ans;
    auto last = new long[](26);
    last[] = -1;
    foreach (d; 0 .. D)
    {
        // dprint(S[d], T[d]);
        ans += S[d][T[d]];
        last[T[d]] = d;
        foreach (i; 0 .. 26)
        {
            ans -= (d - last[i]) * C[i];
        }
        // writeln(ans);
    }
    writeln(max(1_000_000 + ans, 0));
}
