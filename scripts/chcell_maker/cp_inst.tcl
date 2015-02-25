dm::copyCells [dm::getCells edge4 -libName new] -libDestName new2  -cellDestName xt
set cell_dell [oa::DesignOpen new2 edge4 layout readOnly]
le::flatten [de::getFigures {{-4 -4} {100 100 }} -design $cell_dell] -levels 10
