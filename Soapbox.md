    data_clas = TextClasDataBunch.from_df("output", train_df=df, valid_df=df, bs=32)
    learner = load_learner("api/models", "classification.pkl")
    learner.data = data_clas
    

​        learner = load_learner("api/models", "classification.pkl")

​        learner.data = data_clas



```python
{nan, 'Security Question', 'Bug', 'Wistia', 'restart trial', 'Delete SoapBox', 'How do I?', 'Pricing feedback', 'Negative feedback', 'Generic Feedback', 'Change request', 'one-off meetings', 'android feedback', 'Feature - Search', 'Positive Feedback', 'Feature Request', 'marketing', 'churn'}
```

