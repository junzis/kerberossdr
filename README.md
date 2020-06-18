# KerberosSDR Lite


This a fork of [rtlsdrblog/kerberossdr](https://github.com/rtlsdrblog/kerberossdr), with web modules removed. It also changes the Qt envrioment from Qt4 to Qt5.


## Installation

[Optional] deactivate conda environment if enabled:

```
conda deactivate
```

Install Dependencies:

```
sudo apt update

sudo apt install python3-pip python3-pyqt5 pyqt5-dev-tools \
  build-essential gfortran libatlas3-base libatlas-base-dev \
  python3-dev python3-setuptools libffi7 libffi-dev python3-tk \
  pkg-config libfreetype6-dev
```

Uninstall any preinstalled numpy packages as we want to install with pip3 to get optimized BLAS.

```
sudo apt remove python3-numpy
```

Install Dependencies via pip3:

```
pip3 install numpy matplotlib scipy pyapril pyargus pyqtgraph
```

## Initialization

```
git clone https://github.com/junzis/kerberossdr
cd kerberossdr
make
```


## Running

[Optional] deactivate conda environment if enabled:

```
conda deactivate
```

Start the script

```
./run.sh
```

## Reference

Tutorial of the original kerberossdr tool at www.rtl-sdr.com/ksdr
