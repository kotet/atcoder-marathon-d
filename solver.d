// dfmt off
T lread(T=long)(){return readln.chomp.to!T;}T[] lreads(T=long)(long n){return iota(n).map!((_)=>lread!T).array;}
T[] aryread(T=long)(){return readln.split.to!(T[]);}void arywrite(T)(T a){a.map!text.join(' ').writeln;}
void scan(L...)(ref L A){auto l=readln.split;foreach(i,T;L){A[i]=l[i].to!T;}}alias sread=()=>readln.chomp();
void dprint(L...)(lazy L A){debug{auto l=new string[](L.length);static foreach(i,a;A)l[i]=a.text;arywrite(l);}}
static immutable MOD=10^^9+7;alias PQueue(T,alias l="b<a")=BinaryHeap!(Array!T,l);import std;
// dfmt on

void main()
{
    static import std.datetime.stopwatch;

    std.datetime.stopwatch.StopWatch sw;
    sw.start();

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

    alias ST = Tuple!(long, long, long[]); // i,j,dirs

    auto visited = new bool[](50 * 50);

    long[] dirs(long ci, long cj)
    {
        long[] ret;
        if (0 < ci && !visited[T[ci - 1][cj]])
        {
            ret ~= dir.U;
        }
        if (ci < 49 && !visited[T[ci + 1][cj]])
        {
            ret ~= dir.D;
        }
        if (0 < cj && !visited[T[ci][cj - 1]])
        {
            ret ~= dir.L;
        }
        if (cj < 49 && !visited[T[ci][cj + 1]])
        {
            ret ~= dir.R;
        }
        randomShuffle(ret);
        return ret;
    }

    DList!ST Q;

    long max_pts;
    char[] ans;

    long acc;
    char[] log;

    void go(long ci, long cj)
    {
        acc += P[ci][cj];
        visited[T[ci][cj]] = true;
        Q.insertFront(ST(ci, cj, dirs(ci, cj)));
    }

    go(si, sj);

    while (!Q.empty && sw.peek() < dur!"msecs"(1950))
    {
        // writeln(acc, log);
        auto st = Q.front;
        Q.removeFront();
        long ci = st[0];
        long cj = st[1];
        long[] d = st[2];

        long t = T[ci][cj];
        long p = P[ci][cj];

        if (max_pts < acc)
        {
            max_pts = acc;
            ans = log.dup;
        }

        if (d.length == 0)
        {
            acc -= p;
            log = log[0 .. max($ - 1, 0)];
            visited[t] = false;
            continue;
        }
        Q.insertFront(ST(ci, cj, d[1 .. $].dup));
        switch (d[0])
        {
        case dir.U:
            log ~= 'U';
            go(ci - 1, cj);
            break;
        case dir.D:
            log ~= 'D';
            go(ci + 1, cj);
            break;
        case dir.L:
            log ~= 'L';
            go(ci, cj - 1);
            break;
        case dir.R:
            log ~= 'R';
            go(ci, cj + 1);
            break;
        default:
            assert(0);
        }
    }

    writeln(ans);

    // alias Result = Tuple!(long, char[]);

    // Result solve()
    // {
    //     long ci = si;
    //     long cj = sj;

    //     auto visited = new bool[](50 * 50);
    //     long pts;
    //     char[] ans;

    //     while (true)
    //     {
    //         pts += P[ci][cj];
    //         long t = T[ci][cj];
    //         visited[t] = true;
    //         long[] dirs;
    //         if (0 < ci && !visited[T[ci - 1][cj]])
    //         {
    //             dirs ~= dir.U;
    //         }
    //         if (ci < 49 && !visited[T[ci + 1][cj]])
    //         {
    //             dirs ~= dir.D;
    //         }
    //         if (0 < cj && !visited[T[ci][cj - 1]])
    //         {
    //             dirs ~= dir.L;
    //         }
    //         if (cj < 49 && !visited[T[ci][cj + 1]])
    //         {
    //             dirs ~= dir.R;
    //         }
    //         if (dirs.length == 0)
    //         {
    //             return Result(pts, ans);
    //         }
    //         long d = dirs[uniform(0, dirs.length, rand)];
    //         switch (d)
    //         {
    //         case dir.U:
    //             ans ~= 'U';
    //             ci--;
    //             break;
    //         case dir.D:
    //             ans ~= 'D';
    //             ci++;
    //             break;
    //         case dir.L:
    //             ans ~= 'L';
    //             cj--;
    //             break;
    //         case dir.R:
    //             ans ~= 'R';
    //             cj++;
    //             break;
    //         default:
    //             assert(0);
    //         }
    //     }
    // }

    // long max_pts;
    // char[] ans;

    // while (sw.peek() < dur!"msecs"(1900))
    // {
    //     auto r = solve();
    //     if (max_pts < r[0])
    //     {
    //         max_pts = r[0];
    //         ans = r[1];
    //     }
    // }

    // writeln(ans);
}

enum dir
{
    U,
    D,
    L,
    R,
}
