#!/bin/bash
filename=classSchedule.txt

rough=$(cat classSchedule.txt)
tmp=$(expr index "$rough" '*;')
mon=${rough:0:tmp}

rough=${rough:tmp}
tmp=$(expr index "$rough" '*;')
tue=${rough:0:tmp}

rough=${rough:tmp}
tmp=$(expr index "$rough" '*;')
wed=${rough:0:tmp}

rough=${rough:tmp}
tmp=$(expr index "$rough" '*;')
thu=${rough:0:tmp}

rough=${rough:tmp}
tmp=$(expr index "$rough" '*;')
fri=${rough:0:tmp}

