# Image-Retargeting

This is an implementation of bidirectional similarity method on image retargeting, the final project of the course ECE178-F16 of UCSB.

Begin with a rare image, even though within some certain steps different methods can be substituted by each other, in general we follow the steps below at a high level to achieve our result:

Resize the rare image into a coarsest-scaled one;

Retargeting at the coarsest scale;

Gradual resolution refinement;

Final scale refinement.

The retargeting is done only at the coarsest scale, in order to lower the total amount of time spent. Randomized Correspondence Patch Match Approach is used to resize the image to a larger scale. Then, the Vote & Update Rule considering the coherence and completeness of the image is used for refining.
