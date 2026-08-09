#!/bin/csh -vf

pegasusDesignReview -batch dbmerge pdr_CTL_aref darkio.fill_aref.gds.gz

pegasusDesignReview -batch dbmerge pdr_CTL darkio.wFill.gds.gz
