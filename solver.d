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
        // randomShuffle(ret, rand);
        return ret;
    }

    ST[50 * 50] Q;
    long q_len;

    long max_pts;
    string ans;

    long acc;
    char[50 * 50] log;
    long log_len;

    void go(long ci, long cj)
    {
        acc += P[ci][cj];
        visited[T[ci][cj]] = true;
        Q[q_len++] = ST(ci, cj, dirs(ci, cj).dup);
        // Q.insertFront(ST(ci, cj, dirs(ci, cj).idup));
    }

    go(si, sj);

    auto last = sw.peek();

    auto now = sw.peek();

    long last_iter;
    long iter;

    long rewind_cnt;

    while (q_len && now < dur!"msecs"(1985))
    {
        iter++;
        if ((iter & ((1 << 9) - 1)) == 0)
        {
            // writeln(iter);
            now = sw.peek();
        }

        if (dur!"msecs"(1) < now - last)
        {
            // writeln(iter - last_iter, " ", acc);
            last_iter = iter;
            if (max_pts < acc)
            {
                max_pts = acc;
                ans = log[0 .. log_len].dup;
            }
            rewind_cnt = uniform(log_len / 4, log_len, rand);
            // writeln(rewind_cnt);
            // rewind_cnt = log_len / 2;
            // acc = 0;
            // log_len = 0;
            // visited[] = false;
            // // Q.clear();
            // q_len = 0;
            // go(si, sj);
            last = now;
        }

        auto st = Q[--q_len];
        // auto st = Q.front;
        // Q.removeFront();
        long ci = st[0];
        long cj = st[1];
        auto d = st[2];

        long t = T[ci][cj];
        long p = P[ci][cj];

        if (d.length == 0 || rewind_cnt)
        {
            if (rewind_cnt)
                rewind_cnt--;
            if (last)
                acc -= p;
            log_len--;
            visited[t] = false;
            continue;
        }
        Q[q_len++] = ST(ci, cj, d[1 .. $].dup);
        // Q.insertFront(ST(ci, cj, d[1 .. $].idup));
        switch (d[0])
        {
        case dir.U:
            log[log_len++] = 'U';
            go(ci - 1, cj);
            break;
        case dir.D:
            log[log_len++] = 'D';
            go(ci + 1, cj);
            break;
        case dir.L:
            log[log_len++] = 'L';
            go(ci, cj - 1);
            break;
        case dir.R:
            log[log_len++] = 'R';
            go(ci, cj + 1);
            break;
        default:
            assert(0);
        }
    }

    if (max_pts < acc)
    {
        max_pts = acc;
        ans = log[0 .. log_len].idup;
    }

    writeln(ans);
}

enum dir
{
    U,
    D,
    L,
    R,
}
