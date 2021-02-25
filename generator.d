// dfmt off
T lread(T=long)(){return readln.chomp.to!T;}T[] lreads(T=long)(long n){return iota(n).map!((_)=>lread!T).array;}
T[] aryread(T=long)(){return readln.split.to!(T[]);}void arywrite(T)(T a){a.map!text.join(' ').writeln;}
void scan(L...)(ref L A){auto l=readln.split;foreach(i,T;L){A[i]=l[i].to!T;}}alias sread=()=>readln.chomp();
void dprint(L...)(lazy L A){debug{auto l=new string[](L.length);static foreach(i,a;A)l[i]=a.text;arywrite(l);}}
static immutable MOD=10^^9+7;alias PQueue(T,alias l="b<a")=BinaryHeap!(Array!T,l);import std;
// dfmt on

void main(string[] argv)
{
    // import core.thread.osthread;

    // Thread.sleep(dur!"msecs"(1000));
    auto rand = Mt19937_64(argv[1].to!long);
    writeln(365);
    auto c = generate!(() => uniform(0, 100 + 1, rand)).take(26).array();
    arywrite(c);
    foreach (d; 0 .. 365)
    {
        auto s = generate!(() => uniform(0, 20000 + 1, rand)).take(26).array();
        arywrite(s);
    }
}
