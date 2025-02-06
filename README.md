# PyGEM-notebooks
Included in this repository are a series of Jupyter notebooks intended to demonstrate the functionality of the [Python Glacier Evolution Model (PyGEM)](https://github.com/PyGEM-Community/PyGEM).  These notebooks generally follow [PyGEM's documentation](https://pygem.readthedocs.io/en/latest/).


## Notebooks
### Model testing
The following Jupyter notebooks are intended to allow for introduction and testing of PyGEM and may be run using sample data that should have been downloaded during model installation and setup (see [here](https://pygem.readthedocs.io/en/latest/install_pygem.html)), but can also be downloaded directly [here](https://drive.google.com/file/d/1Wu4ZqpOKxnc4EYhcRHQbwGq95FoOxMfZ/view?usp=drive_link).<br>
- [simple_test](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/simple_test.ipynb): simple introductory PyGEM test run using provided sample data for Khumbu Glacier<br>
- [advanced_test](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/advanced_test.ipynb): a more advanced PyGEM test run, demonstrating Bayesian inference calibration and simulation, using provided sample data for Khumbu Glacier<br>
- [advanced_test_tw](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/advanced_test_tw.ipynb): demonstrates calibration of the frontal ablation parameterization, using provided sample data for LeConte Glacier<br>
>**Note:** The model testing notebooks listed above will only run on the specified glaciers, _unless_ all the necessary input data for other glaciers of interest are separately downloaded or exist elsewhere on one's computer (in which case, update the `root` path in *~/PyGEM/config.yaml*).  See below for futher information.

### Further demonstration
The notebooks listed below serve as more advanced demonstration of PyGEM.  However, running these notebooks requires more comprehensive datasets, as the sample data utilized in the above notebooks are subset to the two specified test glaciers.  Complete PyGEM datasets used to run these notebooks (e.g., climate, reference mass balance, frontal ablation, etc.) can be downloaded [here](https://cmu.box.com/s/p8aiby5s9f3n6ycgmhknbgo4htk3pn9j).<br>
- [run_calibration](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/run_calibration.ipynb): demonstrates how to run PyGEM calibration routines<br>
- [run_simulation](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/run_simulation.ipynb): demonstrates how to run individual or large-scale (regional) glacier simulations<br>
- [analyze_regional_change](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/analyze_regional_change.ipynb): demonstrates how to aggregate individual glacier simulations by region and climate scenario, and analyze the resulting regional change<br>
- [analyze_mcmc](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/analyze_mcmc.ipynb): demonstrates how to analyze the prior and posterior model parameters for an individual glacier following **MCMC** model calibration<br>
- [analyze_mcmc_regional](https://github.com/PyGEM-Community/PyGEM-notebooks/blob/main/analyze_mcmc_regional.ipynb): demonstrates how to analyze the performance of **MCMC** calibration for an entire region<br>


## Wrappers 
Within the wrappers subdirectory, one can find example PyGEM wrappers for executing calibration and/or simulation using a shell script, or a slurm script.