void update_396(UC* addr, UC val) {
  if (check_pos_f) {
    for (unsigned i = 0; i < n; i++) {
      ((LFusedTcFlagLoad*)addr)->update();
      addr += sizeof(LFusedTcFlagLoad);
    }
  } else {
    addr += n * sizeof(LFusedTcFlagLoad);
  }


  if (check_pos_v) {
    for (unsigned i = 0; i < n; i++) {
      ((LDBSTcCheckLoad*)addr)->update();
      addr += sizeof(LDBSTcCheckLoad);
    }
    ((LDBSTimingCheckLoadQ*)addr)->update();
    addr += sizeof(LDBSTimingCheckLoadQ);
  } else {
    addr += n * sizeof(LDBSTcCheckLoad);
    addr += sizeof(LDBSTimingCheckLoadQ);
  }
}
