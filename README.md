# helm-sx.el  

Emacs Helm interface for [sx.el - StackExchange client](https://github.com/vermiculus/sx.el)  
Once evaluated this file will declare Helm sources and functions for all Stack Exchange forums;  
sources are called `helm-source-sx-$forum` for example `helm-source-sx-stackoverflow`.  
helm functions for particular forum are called `helm-sx-$site` eg `helm-sx-stackoverflow`.  

## Installation  

You can just download file `helm-sx.el` and install it using `M-x package-install-file`.  
[el-get recipe](https://github.com/dimitri/el-get/pull/2949) is also available.  
