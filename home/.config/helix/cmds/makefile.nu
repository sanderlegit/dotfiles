export def init-makefile [] {}

def "main handle-inner" [] {
  try { fzf-make }
  print "Press <Any> To Continue!"
  input -n 1 -s
}

def "main last handle-inner" [] {
  try { fzf-make -r }
  print "Press <Any> To Continue!"
  input -n 1 -s
}

def "main wait" [] {
  zellij run -f -c -- nu $"($env.ZELLIX_MOD)/makefile.nu" handle-inner
}

def "main last wait" [] {
  zellij run -f -c -- nu $"($env.ZELLIX_MOD)/makefile.nu" last handle-inner
}

def "main last" [] {
  zellij run -f -c -- fzf-make -r
}

def main [] {
  zellij run -f -c -- fzf-make
}
