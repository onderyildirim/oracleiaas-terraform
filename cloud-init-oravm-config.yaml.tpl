#cloud-config

write_files:
  - path: /home/azureuser/configurevm.sh
    owner: azureuser:azureuser
    permissions: '0755'
    content: |
      #!/bin/bash

      oraMntDir=${oraMntDir}
      ANFipAddr=${ANFipAddr}
      ANFvolumeName=${ANFvolumeName}

      _oraOsAcct="oracle"
      _oraOsGroup="oinstall"
      _workDir="/home/azureuser/logs"
      _logFile="${_workDir}/log_$(date +%F).log"

      if [ ! -d "$_workDir" ]; then
          mkdir -p $_workDir
      fi
      touch _logFile

      echo "`date` - INF: Parameters" | tee -a ${_logFile}
      echo "`date` - INF:     oraMntDir    =${oraMntDir}" | tee -a ${_logFile}
      echo "`date` - INF:     ANFipAddr    =${ANFipAddr}" | tee -a ${_logFile}
      echo "`date` - INF:     ANFvolumeName=${ANFvolumeName}" | tee -a ${_logFile}
      echo "`date` - INF:     _oraOsAcct   =${_oraOsAcct}" | tee -a ${_logFile}
      echo "`date` - INF:     _oraOsGroup  =${_oraOsGroup}" | tee -a ${_logFile}
      echo "`date` - INF:     _workDir     =${_workDir}" | tee -a ${_logFile}
      echo "`date` - INF:     _logFile     =${_logFile}" | tee -a ${_logFile}

      echo "`date` - CMD: mkdir -p $oraMntDir" | tee -a ${_logFile}
      sudo mkdir -p $oraMntDir >> ${_logFile} 2>&1

      echo "`date` - CMD: sudo mount -t nfs -o rw,hard,rsize=1048576,wsize=1048576,sec=sys,vers=3,tcp $ANFipAddr:/$ANFvolumeName $oraMntDir" | tee -a ${_logFile}
      sudo mount -t nfs -o rw,hard,rsize=1048576,wsize=1048576,sec=sys,vers=3,tcp $ANFipAddr:/$ANFvolumeName $oraMntDir >> ${_logFile} 2>&1

      echo "`date` - CMD: chown ${_oraOsAcct}:${_oraOsGroup} $oraMntDir" | tee -a ${_logFile}
      sudo chown ${_oraOsAcct}:${_oraOsGroup} $oraMntDir >> ${_logFile} 2>&1

# run commands
# default: none
# runcmd contains a list of either lists or a string
# each item will be executed in order at rc.local like level with
# output to the console
# - runcmd only runs during the first boot
# - if the item is a list, the items will be properly executed as if
#   passed to execve(3) (with the first arg as the command).
# - if the item is a string, it will be simply written to the file and
#   will be interpreted by 'sh'
#
# Note, that the list has to be proper yaml, so you have to quote
# any characters yaml would eat (':' can be problematic)
runcmd:
 - cd /home/azureuser
 - /home/azureuser/configurevm.sh
#  - [ sh, -xc, "echo $(date) ': hello world!'" ]
#  - [ sh, -c, echo "=========hello world=========" ]
#  - ls -l /root
#  # Note: Don't write files to /tmp from cloud-init use /run/somedir instead.
#  # Early boot environments can race systemd-tmpfiles-clean LP: #1707222.
#  - mkdir /run/mydir
#  - [ wget, "http://slashdot.org", -O, /run/mydir/index.html ]