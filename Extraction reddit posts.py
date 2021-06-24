#!/usr/bin/env python
# coding: utf-8

# In[5]:


from pprint import pprint
import pandas as pd
import numpy as no
import matplotlib.pyplot as plt
import seaborn as sns


# In[35]:


import praw 
import datetime as dt

user_agent = "RScraper"
reddit = praw.Reddit(
client_id ="OzJxTmJX9eY2fw",
client_secret = "Lkv6dk5K2YvyUJnVM3Qdg1dV2BEdnA",
user_agent = user_agent)


# In[18]:


subreddit1 = reddit.subreddit('QAnonCasualties')
python_subreddit = subreddit1.top(limit=500)


# In[19]:


dict =        { "title":[],
                "subreddit":[],
                "score":[], 
                "id":[], 
                "url":[], 
                "comms_num": [], 
                "created": [], 
                "body":[]}


# In[20]:


for submission in python_subreddit:
    dict["title"].append(submission.title)
    dict['subreddit'].append(submission.subreddit)
    dict["score"].append(submission.score)
    dict["id"].append(submission.id)
    dict["url"].append(submission.url)
    dict["comms_num"].append(submission.num_comments)
    dict["created"].append(submission.created)
    dict["body"].append(submission.selftext)


# In[47]:


def get_date(created):
    return dt.datetime.fromtimestamp(created)
_timestamp = df["created"].apply(get_date)
df = df.assign(timestamp = _timestamp)


# In[48]:


df = pd.DataFrame(dict)
print(df)
    


# In[38]:


df.to_csv (r'C:\Users\Ioana\Desktop\export_dataframe.csv', index = False, header=True)


# In[ ]:




