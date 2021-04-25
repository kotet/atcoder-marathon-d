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

    alias ST = Tuple!(long, long, bool[50 * 50], string, long); // i,j,visited,log,pts

    long[] dirs(long ci, long cj, bool[50 * 50] visited)
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

    DList!ST Q;

    // long acc;
    // long log_len;

    // void go(long ci, long cj)
    // {
    //     acc += P[ci][cj];
    //     visited[T[ci][cj]] = true;
    //     Q[q_len++] = ST(ci, cj, dirs(ci, cj).dup);
    //     // Q.insertFront(ST(ci, cj, dirs(ci, cj).idup));
    // }

    // go(si, sj);

    // auto last = sw.peek();

    auto now = sw.peek();

    long iter;

    Q.insertBack(ST(si, sj, (bool[50 * 50]).init, "", 0));

    long global_max_pts;
    string global_max_ans;

    long dfs(ST st)
    {
        long max_pts;
        string max_ans;
        DList!ST stack;
        stack.insertFront(st);
        long iter;
        while (!stack.empty && iter < 500)
        {
            iter++;
            auto cur = stack.front;
            stack.removeFront();
            long ci = cur[0];
            long cj = cur[1];
            auto visited = cur[2];
            auto log = cur[3];
            long pts = cur[4];

            pts += P[ci][cj];
            visited[T[ci][cj]] = true;
            auto ds = dirs(ci, cj, visited);
            if (max_pts < pts)
            {
                max_pts = pts;
                max_ans = log;
                if (global_max_pts < pts)
                {
                    global_max_pts = pts;
                    global_max_ans = log;
                }
            }
            foreach (d; ds)
            {
                switch (d)
                {
                case dir.U:
                    stack.insertFront(ST(ci - 1, cj, visited, log ~ 'U', pts));
                    break;
                case dir.D:
                    stack.insertFront(ST(ci + 1, cj, visited, log ~ 'D', pts));
                    break;
                case dir.L:
                    stack.insertFront(ST(ci, cj - 1, visited, log ~ 'L', pts));
                    break;
                case dir.R:
                    stack.insertFront(ST(ci, cj + 1, visited, log ~ 'R', pts));
                    break;
                default:
                    assert(0);
                }
            }
        }
        return max_pts;
    }

    while (!Q.empty && now < dur!"msecs"(1985))
    {
        iter++;
        now = sw.peek();

        auto cur = Q.front;
        Q.removeFront();
        long ci = cur[0];
        long cj = cur[1];
        auto visited = cur[2];
        auto log = cur[3];
        long pts = cur[4];

        pts += P[ci][cj];
        visited[T[ci][cj]] = true;
        auto ds = dirs(ci, cj, visited);
        if (global_max_pts < pts)
        {
            global_max_pts = pts;
            global_max_ans = log;
        }
        auto evals = new long[](ds.length);
        // writeln(global_max_pts);
        if (ds.length == 0)
        {
            continue;
        }

        foreach (i; 0 .. ds.length)
        {
            switch (ds[i])
            {
            case dir.U:
                evals[i] = dfs(ST(ci - 1, cj, visited, log ~ 'U', pts));
                break;
            case dir.D:
                evals[i] = dfs(ST(ci + 1, cj, visited, log ~ 'D', pts));
                break;
            case dir.L:
                evals[i] = dfs(ST(ci, cj - 1, visited, log ~ 'L', pts));
                break;
            case dir.R:
                evals[i] = dfs(ST(ci, cj + 1, visited, log ~ 'R', pts));
                break;
            default:
                assert(0);
            }
        }

        zip(evals, ds).sort!"b<a"();

        long k = max(1, ds.length / 2);

        foreach (i; 0 .. k)
        {
            switch (ds[i])
            {
            case dir.U:
                Q.insertBack(ST(ci - 1, cj, visited, log ~ 'U', pts));
                break;
            case dir.D:
                Q.insertBack(ST(ci + 1, cj, visited, log ~ 'D', pts));
                break;
            case dir.L:
                Q.insertBack(ST(ci, cj - 1, visited, log ~ 'L', pts));
                break;
            case dir.R:
                Q.insertBack(ST(ci, cj + 1, visited, log ~ 'R', pts));
                break;
            default:
                assert(0);
            }
        }

        // auto st = Q[--q_len];
        // // auto st = Q.front;
        // // Q.removeFront();
        // long ci = st[0];
        // long cj = st[1];
        // auto d = st[2];

        // long t = T[ci][cj];
        // long p = P[ci][cj];

        // if (d.length == 0 && dur!"msecs"(1) < now - last)
        // {
        //     // writeln(iter - last_iter, " ", acc);
        //     // last_iter = iter;
        //     if (max_pts < acc)
        //     {
        //         max_pts = acc;
        //         ans = log[0 .. log_len].dup;
        //     }
        //     rewind_cnt = uniform(log_len / 4, log_len, rand);
        //     // writeln(rewind_cnt);
        //     // rewind_cnt = log_len / 2;
        //     // acc = 0;
        //     // log_len = 0;
        //     // visited[] = false;
        //     // // Q.clear();
        //     // q_len = 0;
        //     // go(si, sj);
        //     last = now;
        // }

        // if (d.length == 0 || rewind_cnt)
        // {
        //     if (rewind_cnt)
        //         rewind_cnt--;
        //     if (last)
        //         acc -= p;
        //     log_len--;
        //     visited[t] = false;
        //     continue;
        // }
        // Q[q_len++] = ST(ci, cj, d[1 .. $].dup);
        // // Q.insertFront(ST(ci, cj, d[1 .. $].idup));
    }

    writeln(global_max_ans);
}

enum dir
{
    U,
    D,
    L,
    R,
}
