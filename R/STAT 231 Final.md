```R
# Following line ran automatically after going to Environment and manually importing dataset
> exam <- read.table("~/Desktop/STAT 231/Final/exam.txt", quote="\"", comment.char="")
> cor(exam$V1, exam $V2)
[1] 0.5783698
> exam$Diff <- exam$V1 - exam$V2
> help(t.test)
> t.test(exam$V1, exam$V2, paired=TRUE, conf.level=0.95)

	Paired t-test

data:  exam$V1 and exam$V2
t = 1.5835, df = 24, p-value = 0.1264
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.4416677  3.3536677
sample estimates:
mean of the differences 
                  1.456 
> s<-sd(exam$V1-exam$V2)
> s
[1] 4.597289
```

