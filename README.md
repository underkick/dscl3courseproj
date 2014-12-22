dscl3courseproj
===============

Course Project - Getting and Cleaning Data

This figure in this comment shows how the files fit into the data frame.
https://class.coursera.org/getdata-016/forum/thread?thread_id=50#comment-333

The code merges those files together like that.

The data is filtered so that only the test data with -std() or -mean() are included (besides the person and 
activity columns).

Make.names is used to ensure column names are legal.

The data is grouped by person and activity so that the average readings for std and mean can be written to
the output table.

