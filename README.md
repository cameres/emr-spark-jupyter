# EMR, Spark, & Jupyter
In this tutorial, I'm going to setup a data environment with Amazon EMR, Apache Spark, and Jupyter Notebook. Apache Spark has gotten extremely popular for big data processing and machine learning and EMR makes it incredibly simple to provision a Spark Cluster in minutes! At Mozilla we frequently spin up Spark clusters to perform data analysis and we have a [repository]() for scripts for provisioning our clusters. The scripts contained in this repository extract the functionality that is specific to creating a simple Spark cluster and installing Jupyter Notebook on the main node of the cluster.

## Assumptions
The major assumption that I make in the following tutorial is that your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are accessible to `awscli`. This can be solved by placing the following environmental variables in the environment file of your respective shell. There might be other solutions to this problem, but I personally use this solution.

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

## Setting Up Key Pair Using EC2
In order to access the cluster from via the command line later, you need to generate a Key Pair used to ssh into the main node. I haven't been able to figure out a way in which to create a key pair using the `awscli` and have it work with the remainder of the script. Thus I recommend setting up a Key Pair using the [EC2 User Guide](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair). Make sure to place the private key in this directory in order to run the script.

## Configuring the Script
The following two variables need to be altered in based on your use case. They are found in `install-jupyter-notebook` and `script.sh`.

```bash
# bucket should be created and used on s3
SPARK_BUCKET="bucket-to-create-on-s3"
# name of the key pair ex: MyKeyPair
SPARK_KEY_PAIR="key-pair-created-in-first-step"
```

## Configuring Jupyter Notebook
`jupyter_notebook_config.py` is used to configure Jupyter Notebook on the main node. As an example, this file can be altered to set a password for access to notebooks. Below is the code for generating a password for notebooks.

```python
from notebook.auth import passwd
# get a hashed password
passwd('password')
```

## Running the Script
After following the above steps, you can run the script to provision the cluster using `bash script.sh`. Each command can also be run separately in your shell if that is preferred.

## Accesing Jupyter
In order to forward the notebook server and access Jupyter, we invoke the following command. Make sure
that the private key has the proper permissions before running the command (if you followed
the AWS guide it should)!

```bash
ssh -L 8888:localhost:8888 hadoop@ec2-**-***-***-*.us-west-1.compute.amazonaws.com -i <key pair>.pem  
```

Now we can open localhost:8888 in a web browser and access our Spark context as if it was running
locally on our computer.


## TODO
- break `script.sh` file into a user configurable file and a template file
- allow parameters?
