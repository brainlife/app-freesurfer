#!/usr/bin/env python

import vtk
import sys
import os
import json
import pandas as pd

if not os.path.exists("surfaces"):
   os.makedirs("surfaces")

#lut = pd.read_csv('FreeSurferColorLUT.csv')
with open("labels.json") as f:
    labels = json.load(f)
img_path = 'aparc+aseg.nii.gz'

# import the binary nifti image
print("loading %s" % img_path)
reader = vtk.vtkNIFTIImageReader()
reader.SetFileName(img_path)
reader.Update()

print("list unique values (super slow!)")
out = reader.GetOutput()
vtk_data=out.GetPointData().GetScalars()
unique = set()
for i in range(0, vtk_data.GetSize()):
    v = vtk_data.GetValue(i)
    unique.add(v)

index=[]

for label in labels:
    label_id=int(label["label"])

    #only handle some surfaces
    #if label_id < 1000 or label_id > 2036:
    #    continue
    if not label_id in unique:
        continue

    surf_name=label['label']+'.'+label['name']+'.vtk'
    label["filename"] = surf_name
    print(surf_name)

    #label["label"] = label_id
    index.append(label)

    # do marching cubes to create a surface
    surface = vtk.vtkDiscreteMarchingCubes()
    surface.SetInputConnection(reader.GetOutputPort())

    # GenerateValues(number of surfaces, label range start, label range end)
    surface.GenerateValues(1, label_id, label_id)
    surface.Update()
    #print(surface)

    smoother = vtk.vtkWindowedSincPolyDataFilter()
    smoother.SetInputConnection(surface.GetOutputPort())
    smoother.SetNumberOfIterations(10)
    smoother.NonManifoldSmoothingOn()
    smoother.NormalizeCoordinatesOn()
    smoother.Update()

    connectivityFilter = vtk.vtkPolyDataConnectivityFilter()
    connectivityFilter.SetInputConnection(smoother.GetOutputPort())
    connectivityFilter.SetExtractionModeToLargestRegion()
    connectivityFilter.Update()

    untransform = vtk.vtkTransform()
    untransform.SetMatrix(reader.GetQFormMatrix())
    untransformFilter=vtk.vtkTransformPolyDataFilter()
    untransformFilter.SetTransform(untransform)
    untransformFilter.SetInputConnection(connectivityFilter.GetOutputPort())
    untransformFilter.Update()

    cleaned = vtk.vtkCleanPolyData()
    cleaned.SetInputConnection(untransformFilter.GetOutputPort())
    cleaned.Update()

    deci = vtk.vtkDecimatePro()
    deci.SetInputConnection(cleaned.GetOutputPort())
    deci.SetTargetReduction(0.5)
    deci.PreserveTopologyOn()

    writer = vtk.vtkPolyDataWriter()
    writer.SetInputConnection(deci.GetOutputPort())
    writer.SetFileName("surfaces/"+surf_name)
    writer.Write()

print("writing surfaces/index.json")
with open("surfaces/index.json", "w") as outfile:
    json.dump(index, outfile)

print("all done")
