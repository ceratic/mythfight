if ($build == 1)
    
    width = IAVRA::INI.load('Settings', 'defScreenW', '0').to_i
    height = IAVRA::INI.load('Settings', 'defScreenH', '0').to_i

    
    #Do not edit
    wt, ht = width.divmod(32), height.divmod(32)
    wt.last + ht.last == 0 || fail('Incorrect width or height')
    wh = -> w, h, off = 0 { [w + off, h + off].pack('l2').scan /.{4}/ }
    w, h = wh.(width, height)
    ww, hh = wh.(width, height, 32)
    www, hhh = wh.(wt.first.succ, ht.first.succ)
    base = 0x10000000  # fixed?
    mod = -> adr, val { DL::CPtr.new(base + adr)[0, val.size] = val }
    mod.(0x195F, "\x90" * 5)  # ???
    mod.(0x19A4, h)
    mod.(0x19A9, w)
    mod.(0x1A56, h)
    mod.(0x1A5B, w)
    mod.(0x20F6, w)
    mod.(0x20FF, w)
    mod.(0x2106, h)
    mod.(0x210F, h)
    # speed up y?
    mod.(0x1C5E3, h)
    mod.(0x1C5E8, w)
    
    zero = [0].pack ?l
    mod.(0x1C5E3, zero)
    mod.(0x1C5E8, zero)
    mod.(0x1F477, h)
    mod.(0x1F47C, w)
    mod.(0x211FF, hh)
    mod.(0x21204, ww)
    mod.(0x21D7D, hhh[0])
    mod.(0x21E01, www[0])
    mod.(0x10DEA8, h)
    mod.(0x10DEAD, w)
    mod.(0x10DEDF, h)
    mod.(0x10DEF0, w)
    mod.(0x10DF14, h)
    mod.(0x10DF18, w)
    mod.(0x10DF48, h)
    mod.(0x10DF4C, w)
    mod.(0x10E6A7, w)
    mod.(0x10E6C3, h)
    mod.(0x10EEA9, w)
    mod.(0x10EEB9, h)
    Graphics.resize_screen width, height
    GC.start
  end