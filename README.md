# SMO-Algorithm
Implementation of smo algorithm. The kernel function, soft margin are used, and the smo algorithm is optimized.(cache and shrink)

## 2020-11-06 version

According to the idea of the Plott's paper, the most primitive smo algorithm is implemented. 
First, the samples are standardized, and then the sample set and label set are read in matlab, and the training set and the test set are divided. 
The size of the sample set matrix is : m x n (m represents the number of samples, n represents the feature dimension), the label set matrix size is: m x 1.

The multiplier is selected through the inner and outer loops; the penalty coefficient C is set by a given value, and the kernel function is realized: linear kernel, polynomial kernel, RBF kernel and sigmod. The calculation formula of the kernel function is as follows:

Linear :  u * v'
polynomial : (gamma * u * v')^degree
RBF : exp(- gamma * || u * v'|| ^2)
sigmod : tanh(gammga * u * v' + coef0)

Set the value of the parameter by means of global variables.

The training of the classifier is implemented in the file smo.m, and the training samples are used to calculate the accuracy of the classifier in the file TestData.m.

The sample set is: breast sample set which has 658 samples, each sample has 10 features.
