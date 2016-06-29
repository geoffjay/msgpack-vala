/* msgpack.vapi
 *
 * Copyright (C) 2016 Geoff Johnson <geoff.jay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *
 * Author:
 *      Geoff Johnson <geoff.jay@gmail.com>
 */

// XXX is the MSGPACK_DLLEXPORT ... required for some funcs? left off several
[CCode (lower_case_cprefix = "msgpack_")]
namespace MsgPack {

    [CCode (cheader_filename = "msgpack/version.h")]
    public string version ();
    [CCode (cheader_filename = "msgpack/version.h")]
    public int version_major ();
    [CCode (cheader_filename = "msgpack/version.h")]
    public int version_minor ();
    [CCode (cheader_filename = "msgpack/version.h")]
    public int version_revision ();

    [CCode (cprefix = "MSGPACK_", cheader_filename = "msgpack/util.h")]
    public const int UNUSED;

    [CCode (cname = "msgpack_object_type", cprefix = "MSGPACK_OBJECT_", has_type_id = false, cheader_filename = "msgpack/object.h")]
    public enum ObjectType {
        NIL,
        BOOLEAN,
        POSITIVE_INTEGER,
        NEGATIVE_INTEGER,
        FLOAT,
        DOUBLE,
        STR,
        ARRAY,
        MAP,
        BIN,
        EXT
    }

    [CCode (cname = "msgpack_object", cheader_filename = "msgpack/object.h")]
    public struct Object {
        public ObjectType type;
        [CCode (instance_pos = 1.1)]
        public void print (Posix.FILE out);
        [CCode (instance_pos = 1.1)]
        public bool equal (MsgPack.Object y);
    }

    [CCode (cname = "func", has_target = true, cheader_filename = "msgpack/zone.h")]
    public delegate void ZoneFinalizerFunc ();

    [CCode (cname = "msgpack_zone_finalizer", cheader_filename = "msgpack/zone.h")]
    public struct ZoneFinalizer<T> {
        public unowned ZoneFinalizerFunc func;
        public T data;
    }

    [CCode (cname = "msgpack_zone_finalizer_array", cheader_filename = "msgpack/zone.h")]
    public struct ZoneFinalizerArray {
        public ZoneFinalizer tail;
        public ZoneFinalizer end;
        public ZoneFinalizer array;
    }

    [CCode (cname = "msgpack_zone_chunk", cheader_filename = "msgpack/zone.h")]
    public struct ZoneChunk {
        [CCode (cprefix = "MSGPACK_ZONE_CHUNK_")]
        public const int SIZE;
    }

    [CCode (cname = "msgpack_zone_chunk_list", cheader_filename = "msgpack/zone.h")]
    public struct ZoneChunkList {
        public size_t free;
        public string ptr;
        public ZoneChunk head;
    }

    [CCode (cname = "msgpack_zone", free_function = "msgpack_zone_free", destroy_function = "msgpack_zone_destroy", cheader_filename = "msgpack/zone.h")]
    public class Zone {
        [CCode (cprefix = "MSGPACK_ZONE_")]
        public const int ALIGN;

        public ZoneChunkList chunk_list;
        public ZoneFinalizerArray finalizer_array;
        public size_t size;

        [CCode (cname = "msgpack_zone_new")]
        public Zone (size_t chunk_size);
        public bool init (size_t chunk_size);
        public static void* malloc (size_t size);
        public static void* malloc_no_align (size_t size);
        public static bool push_finalizer (ZoneFinalizerFunc func);
        public static void swap (Zone b);
        public bool is_empty ();
        public void clear ();
        public static void* malloc_expand (size_t size);
        public bool push_finalizer_expand (ZoneFinalizerFunc func);
    }

    [CCode (cname = "msgpack_packer_write", has_target = true, delegate_target_pos = 0.1, cheader_filename = "msgpack/pack.h")]
    public delegate int PackerWriteFunc (string buf, size_t len);

    [CCode (cname = "msgpack_packer", free_function = "msgpack_packer_free", unref_function = "msgpack_packer_free", cheader_filename = "msgpack/pack.h")]
    public class Packer {
        [CCode (delegate_target_cname = "data")]
        public PackerWriteFunc callback;

        [CCode (cname = "msgpack_packer_new")]
        public Packer(PackerWriteFunc callback);

        [CCode (cname = "msgpack_pack_char")]
        public int pack_char (char d);
        [CCode (cname = "msgpack_pack_short")]
        public int pack_short (short d);
        [CCode (cname = "msgpack_pack_int")]
        public int pack_int (int d);
        [CCode (cname = "msgpack_pack_long")]
        public int pack_long (long d);
        [CCode (cname = "msgpack_pack_long_long")]
        public int pack_long_long (int64 d);
        [CCode (cname = "msgpack_pack_unsigned_char")]
        public int pack_unsigned_char (uchar d);
        [CCode (cname = "msgpack_pack_unsigned_short")]
        public int pack_unsigned_short (ushort d);
        [CCode (cname = "msgpack_pack_unsigned_int")]
        public int pack_unsigned_int (uint d);
        [CCode (cname = "msgpack_pack_unsigned_long")]
        public int pack_unsigned_long (ulong d);
        [CCode (cname = "msgpack_pack_unsigned_long_long")]
        public int pack_unsigned_long_long (uint64 d);
        [CCode (cname = "msgpack_pack_uint8")]
        public int pack_uint8 (uint8 d);
        [CCode (cname = "msgpack_pack_uint16")]
        public int pack_uint16 (uint16 d);
        [CCode (cname = "msgpack_pack_uint32")]
        public int pack_uint32 (uint32 d);
        [CCode (cname = "msgpack_pack_uint64")]
        public int pack_uint64 (uint64 d);
        [CCode (cname = "msgpack_pack_int8")]
        public int pack_int8 (int8 d);
        [CCode (cname = "msgpack_pack_int16")]
        public int pack_int16 (int16 d);
        [CCode (cname = "msgpack_pack_int32")]
        public int pack_int32 (int32 d);
        [CCode (cname = "msgpack_pack_int64")]
        public int pack_int64 (int64 d);
        [CCode (cname = "msgpack_pack_fix_uint8")]
        public int pack_fix_uint8 (uint8 d);
        [CCode (cname = "msgpack_pack_fix_uint16")]
        public int pack_fix_uint16 (uint16 d);
        [CCode (cname = "msgpack_pack_fix_uint32")]
        public int pack_fix_uint32 (uint32 d);
        [CCode (cname = "msgpack_pack_fix_uint64")]
        public int pack_fix_uint64 (uint64 d);
        [CCode (cname = "msgpack_pack_fix_int8")]
        public int pack_fix_int8 (int8 d);
        [CCode (cname = "msgpack_pack_fix_int16")]
        public int pack_fix_int16 (int16 d);
        [CCode (cname = "msgpack_pack_fix_int32")]
        public int pack_fix_int32 (int32 d);
        [CCode (cname = "msgpack_pack_fix_int64")]
        public int pack_fix_int64 (int64 d);
        [CCode (cname = "msgpack_pack_float")]
        public int pack_float (float d);
        [CCode (cname = "msgpack_pack_double")]
        public int pack_double (double d);
        [CCode (cname = "msgpack_pack_nil")]
        public int pack_nil ();
        [CCode (cname = "msgpack_pack_true")]
        public int pack_true ();
        [CCode (cname = "msgpack_pack_false")]
        public int pack_false ();
        [CCode (cname = "msgpack_pack_array")]
        public int pack_array (size_t n);
        [CCode (cname = "msgpack_pack_map")]
        public int pack_map (size_t n);
        [CCode (cname = "msgpack_pack_str")]
        public int pack_str (size_t l);
        [CCode (cname = "msgpack_pack_str_body")]
        public int pack_str_body (string b, size_t l);
        [CCode (cname = "msgpack_pack_v4raw")]
        public int pack_v4raw (size_t l);
        [CCode (cname = "msgpack_pack_v4raw_body")]
        public int pack_v4raw_body (string b, size_t l);
        [CCode (cname = "msgpack_pack_bin")]
        public int pack_bin (size_t l);
        [CCode (cname = "msgpack_pack_bin_body")]
        public int pack_bin_body (string b, size_t l);
        [CCode (cname = "msgpack_pack_ext")]
        public int pack_ext (size_t l, int8 type);
        [CCode (cname = "msgpack_pack_ext_body")]
        public int pack_ext_body (string b, size_t l);
        [CCode (cname = "msgpack_pack_object")]
        public int pack_object (MsgPack.Object d);
    }

    [CCode (cname = "msgpack_unpacked", destroy_function = "msgpack_unpacked_destroy", cheader_filename = "msgpack/unpack.h")]
    public struct Unpacked {
        public Zone zone;
        public MsgPack.Object data;

        [CCode (instance_pos = 0)]
        public static void init ();
        public static Zone release_zone ();
    }

    [CCode (cheader_filename = "msgpack/unpack.h")]
    namespace Unpack {

        [CCode (cname = "msgpack_unpack_return", cprefix = "MSGPACK_UNPACK_", has_type_id = false)]
        public enum Status {
            SUCCESS,
            EXTRA_BYTES,
            CONTINUE,
            PARSE_ERROR,
            NOMEM_ERROR
        }

        [CCode (cname = "msgpack_unpack_next")]
        public Status next (Unpacked result, string data, size_t len, out size_t off);
    }

    [CCode (icname = "msgpack_unpacker", free_function = "msgpack_unpacker_free", destroy_function = "msgpack_unpacker_destroy", cheader_filename = "msgpack/unpack.h")]
    public class Unpacker<T> {
        [CCode (cprefix = "MSGPACK_UNPACKER_")]
        public const int INIT_BUFFER_SIZE;
        [CCode (cprefix = "MSGPACK_UNPACKER_")]
        public const int RESERVE_SIZE;

        public string? buffer {
            [CCode (cname = "msgpack_unpacker_buffer")]
            get;
            set;
        }
        public size_t used;
        public size_t free;
        public size_t off;
        public size_t parsed;
        public Zone z;
        public size_t initial_buffer_size;
        public T ctx;

        [CCode (cprefix = "msgpack_unpacker_new")]
        public Unpacker (size_t initial_buffer_size);
        public bool init (size_t initial_buffer_size);
        public static bool reserve_buffer (size_t size);
        public static size_t buffer_capacity ();
        public static void buffer_consumed (size_t size);
        public Unpack.Status next (Unpacked pac);
        public int execute ();
        public MsgPack.Object data ();
        public Zone release_zone ();
        public void reset_zone ();
        public void reset ();
        public static size_t message_size ();
        public static size_t parsed_size ();
        public bool flush_zone ();
        public bool expand_buffer (size_t size);
    }

    [CCode (cname = "msgpack_sbuffer", cprefix = "msgpack_sbuffer_", free_function = "msgpack_sbuffer_free", destroy_function = "msgpack_sbuffer_destroy", unref_function = "msgpack_sbuffer_destroy", cheader_filename = "msgpack/sbuffer.h")]
    public class SimpleBuffer {
        [CCode (cprefix = "MSGPACK_SBUFFER_")]
        public const int INIT_SIZE;

        public size_t size;
        public string data;
        public size_t alloc;

        [CCode (cname = "msgpack_sbuffer_new")]
        public SimpleBuffer ();
        public void init ();
        public int write (string buf, size_t len);
        public string release ();
        public void clear ();
    }

    [CCode (cname = "iovec", cheader_filename = "msgpack/vrefbuffer.h")]
    public struct IOVector<T> {
        [CCode (simple_generics = true)]
        T iov_base;
        size_t iov_len;
    }

    [CCode (cname = "msgpack_vrefbuffer_chunk", cheader_filename = "msgpack/vrefbuffer.h")]
    public struct VRefBufferChunk {
    }

    [CCode (cname = "msgpack_vrefbuffer_inner_buffer", cheader_filename = "msgpack/vrefbuffer.h")]
    public class VRefInnerBuffer {
        size_t free;
        string ptr;
        VRefBufferChunk head;
    }

    [CCode (cname = "msgpack_vrefbuffer", cprefix = "msgpack_vrefbuffer_", free_function = "msgpack_vrefbuffer_free", cheader_filename = "msgpack/vrefbuffer.h")]
    public class VRefBuffer {
        [CCode (cprefix = "MSGPACK_VREFBUFFER_")]
        public const int REF_SIZE;
        [CCode (cprefix = "MSGPACK_VREFBUFFER_")]
        public const int CHUNK_SIZE;

        public IOVector tail;
        public IOVector end;
        public IOVector array;
        public size_t chunk_size;
        public size_t ref_size;
        public VRefInnerBuffer inner_buffer;

        [CCode (cname = "msgpack_vrefbuffer_new")]
        public VRefBuffer (size_t ref_size, size_t chunk_size);
        public bool init (size_t ref_size, size_t chunk_size);
        [CCode (has_target = true, instance_pos = -1)]
        public PackerWriteFunc write (string buf, size_t len);
        public IOVector vec ();
        public size_t veclen ();
        public int append_copy (string buf, size_t len);
        public int append_ref (string buf, size_t len);
        public int migrate (VRefBuffer to);
        public void clear ();
    }
}
