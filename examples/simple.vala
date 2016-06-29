
public class Simple {

    public MsgPack.SimpleBuffer sbuf;

    public Simple () {
        sbuf = new MsgPack.SimpleBuffer ();
        sbuf.init ();
    }

    public void prepare () {
        var pk = new MsgPack.Packer (sbuf.write);

        // 1st object
        pk.pack_array (3);
        pk.pack_int (1);
        pk.pack_true ();
        pk.pack_str (7);
        pk.pack_str_body ("example", 7);

        // 2nd object
        pk.pack_str (6);
        pk.pack_str_body ("second", 6);

        // 3rd object
        pk.pack_array (2);
        pk.pack_int (42);
        pk.pack_false ();
    }

    public void unpack () {
        MsgPack.Unpacked result = MsgPack.Unpacked ();
        size_t off = 0;
        MsgPack.Unpack.Status ret;
        int i = 0;

        ret = MsgPack.Unpack.next (result, sbuf.data, sbuf.size, out off);
        while (ret == MsgPack.Unpack.Status.SUCCESS) {
            MsgPack.Object obj = result.data;

            stdout.printf ("Object no %d:\n", ++i);
            obj.print (Posix.stdout);
            stdout.printf ("\n");

            ret = MsgPack.Unpack.next (result, sbuf.data, sbuf.size, out off);
        }

        if (ret == MsgPack.Unpack.Status.CONTINUE) {
            stdout.printf ("All objects in the buffer have been consumed.\n");
        } else if (ret == MsgPack.Unpack.Status.PARSE_ERROR) {
            stdout.printf ("The data in the buffer is in an invalid format.\n");
        }
    }
}

int main (string[] args) {

    var app = new Simple ();

    app.prepare ();
    app.unpack ();

    return 0;
}
