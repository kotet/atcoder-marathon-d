// dfmt off
T lread(T=long)(){return readln.chomp.to!T;}T[] lreads(T=long)(long n){return iota(n).map!((_)=>lread!T).array;}
T[] aryread(T=long)(){return readln.split.to!(T[]);}void arywrite(T)(T a){a.map!text.join(' ').writeln;}
void scan(L...)(ref L A){auto l=readln.split;foreach(i,T;L){A[i]=l[i].to!T;}}alias sread=()=>readln.chomp();
void dprint(L...)(lazy L A){debug{auto l=new string[](L.length);static foreach(i,a;A)l[i]=a.text;arywrite(l);}}
static immutable MOD=10^^9+7;alias PQueue(T,alias l="b<a")=BinaryHeap!(Array!T,l);import std;
// dfmt on

void main()
{

    auto rand = Mt19937_64(42);

    long si, sj;
    scan(si, sj);
    auto T = new long[][](50);
    foreach (i; 0 .. 50)
    {
        T[i] = aryread();
    }
    auto P = new long[][](50);
    foreach (i; 0 .. 50)
    {
        P[i] = aryread();
    }

    alias Result = Tuple!(long, char[]);

    Result solve()
    {
        long ci = si;
        long cj = sj;

        auto visited = new bool[](50 * 50);
        long pts;
        char[] ans;

        while (true)
        {
            pts += P[ci][cj];
            long t = T[ci][cj];
            visited[t] = true;
            long[] dirs;
            if (0 < ci && !visited[T[ci - 1][cj]])
            {
                dirs ~= dir.U;
            }
            if (ci < 49 && !visited[T[ci + 1][cj]])
            {
                dirs ~= dir.D;
            }
            if (0 < cj && !visited[T[ci][cj - 1]])
            {
                dirs ~= dir.L;
            }
            if (cj < 49 && !visited[T[ci][cj + 1]])
            {
                dirs ~= dir.R;
            }
            if (dirs.length == 0)
            {
                return Result(pts, ans);
            }
            long d = dirs[uniform(0, dirs.length, rand)];
            switch (d)
            {
            case dir.U:
                ans ~= 'U';
                ci--;
                break;
            case dir.D:
                ans ~= 'D';
                ci++;
                break;
            case dir.L:
                ans ~= 'L';
                cj--;
                break;
            case dir.R:
                ans ~= 'R';
                cj++;
                break;
            default:
                assert(0);
            }
        }
    }

    writeln(solve()[1]);
}

enum dir
{
    U,
    D,
    L,
    R,
}
