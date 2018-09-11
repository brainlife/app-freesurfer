[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.1-blue.svg)](https://doi.org/10.25663/bl.app.0)

# app-freesurfer

This is a Brainlife wrapper for [Freesurfer](https://surfer.nmr.mgh.harvard.edu/); a popular brain segmentation tool developed by Athinoula A. Martinos Center for Biomedical Imaging at Massachusetts General Hospital. This wrapper executes `recon_all` to generate various data products used by other Brainlife Apps.

![pipeline](http://www.opensourceimaging.org/wp-content/uploads/open-source-imaging-project-upload-freesurfer-pipeline2.jpg)

### Authors
- Franco Pestilli (franpest@indiana.edu)
- Lindsey Kitchell (kitchell@indiana.edu)

### Contributors
- Soichi Hayashi (hayashis@iu.edu)
- Brent McPherson (bcmcpher@iu.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/bl.app.0](https://doi.org/10.25663/bl.app.0) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
    "t1": "/input/t1/t1.nii.gz"
}
```

3. Launch the App by executing `main`

```bash
./main
```

### Sample Datasets

If you don't have your own input file, you can download sample datasets from Brainlife.io, or you can use [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5a050966eec2b300611abff2 && mv 5a050966eec2b300611abff2 input/t1
```

## Output

The main output of this App is a directory named `output`. It contains various freesurfer sub directories.

```
hayashis@xps15:~/Downloads/output $ ls -la
total 40
drwxr-xr-x 10 hayashis hayashis 4096 Nov 10  2017 .
drwx------  3 hayashis hayashis 4096 Sep 11 09:34 ..
drwxrwxr-x  2 hayashis hayashis 4096 Nov 10  2017 label
drwxrwxr-x  4 hayashis hayashis 4096 Nov 10  2017 mri
drwxrwxr-x  2 hayashis hayashis 4096 Nov 10  2017 scripts
drwxrwxr-x  2 hayashis hayashis 4096 Nov 10  2017 stats
drwxrwxr-x  2 hayashis hayashis 4096 Nov 10  2017 surf
drwxrwxr-x  2 hayashis hayashis 4096 Nov 10  2017 tmp
drwxrwxr-x  2 hayashis hayashis 4096 Nov 10  2017 touch
drwxrwxr-x  2 hayashis hayashis 4096 Nov 10  2017 trash
```

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.  

  - Freesurfer: https://surfer.nmr.mgh.harvard.edu/
