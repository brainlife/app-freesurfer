SCA service wrapper for freesurfer/recon-all

## Installation

On IU Karst / Bigred II, git clone this repo

```
git clone git@github.com:brain-life/app-freesurfer.git
```

Create `config.json` with something like following content. config.json provides input parameter for this app.

```
{
    "t1": "/N/u/hayashis/Karst/testdata/sca-service-freesurfer/t1.nii.gz"
}
```

## Running 

On IU Karst / Bigred II, run `start.sh` to kick off your job.

