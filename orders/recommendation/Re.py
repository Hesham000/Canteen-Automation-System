import pandas as pd
import numpy as np
from surprise.model_selection import train_test_split
from surprise import Dataset, Reader
from collections import defaultdict
from surprise import SVD
from surprise import accuracy
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
@app.route('/recommend', methods=['POST'])
def recommend():
    # Set up the connection to your Firebase project
    cred = credentials.Certificate('D:\\Flutter\\orders\\recommendation\\orders-51754-firebase-adminsdk-5snwh-c67313f99a.json')
    firebase_admin.initialize_app(cred)

    # Retrieve the data from the rating collection and convert it to a Pandas DataFrame
    db = firestore.client()
    rating_ref = db.collection('ratings')
    rating_docs = rating_ref.stream()

    rating_data = []
    for doc in rating_docs:
        rating_data.append(doc.to_dict())

    Data = pd.DataFrame(rating_data)
    reader = Reader(rating_scale=(1, 5))
    Data.groupby('product_id')['rating'].mean().head()
    Data.groupby('user_id')['rating'].mean().head()
    Data['user_id'].value_counts().sort_values(ascending=False)
    Datasort1=[x for x in Data['user_id'].value_counts().sort_values(ascending=False) if x>=5]
    len(Datasort1)
    sorted_users1=Data['user_id'].value_counts().sort_values(ascending=False)
    Data2=Data[Data.user_id.isin(sorted_users1.index)]
    Data3=Dataset.load_from_df(Data2[['user_id', 'product_id', 'rating']], reader)
    trainset, testset = train_test_split(Data3, test_size=0.3)
    reader= Reader(rating_scale=(1.0, 5.0))
    algo = SVD()
    algo.fit(trainset)
    predictions2=algo.test(testset)
    predictions2
    accuracy.mae(predictions2, verbose=True)
    accuracy.mse(predictions2, verbose=True)
    accuracy.rmse(predictions2, verbose=True)
    accuracy.fcp(predictions2, verbose=True)

    def get_top_n(predictions, n=5):
        # First map the predictions to each user.
        top_n = defaultdict(list)
        for uid, iid, true_r, est, _ in predictions:
            top_n[uid].append((iid, est))

        # Then sort the predictions for each user and retrieve the k highest ones.
        for uid, user_ratings in top_n.items():
            user_ratings.sort(key=lambda x: x[1], reverse=True)
            top_n[uid] = user_ratings[:n]

        return top_n

    top_5s = get_top_n(predictions2, n=5)

    # Delete all documents in the 'recommendation' collection
    recommendation_ref = db.collection('recommendations')
    recommendation_docs = recommendation_ref.stream()

    for doc in recommendation_docs:
        doc.reference.delete()
    # Store the predictions in the Firestore collection

    for uid, user_ratings in top_5s.items():
        doc_data = {'user_id': uid, 'recommendations': [{'product_id': iid, 'rating': est} for (iid, est) in user_ratings]}
        recommendation_ref.add(doc_data)

    top_5s = get_top_n(predictions2, n=5)
    return jsonify(top_5s)

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)


# The rest of your code

""""
import pandas as pd
import numpy as np
from surprise.model_selection import train_test_split
from surprise import KNNWithMeans
from surprise import *
from surprise import Dataset, Reader
from collections import defaultdict
from surprise import SVD
from surprise import accuracy
import matplotlib.pyplot as plt
import seaborn as sns
# Load the dataset as a Pandas dataframe
Data=pd.read_csv("tourism_rating.csv", names=["User_Id","Place_Id","Place_Rating"],skiprows=1)
Data.head()
reader = Reader(rating_scale=(1, 5))
Data.head()
Data.groupby('Place_Id')['Place_Rating'].mean().head()
Data.groupby('User_Id')['Place_Rating'].mean().head()
Data.isnull().sum()
Data['Place_Rating'].value_counts().sort_index().plot(kind='bar')
plt.xlabel('Place Rating')
plt.ylabel('Count')
plt.title('Count of Place Ratings')
plt.show()
Data['User_Id'].value_counts().sort_values(ascending=False)
Datasort1=[x for x in Data['User_Id'].value_counts().sort_values(ascending=False) if x>=35]
len(Datasort1)
sorted_users1=Data['User_Id'].value_counts().sort_values(ascending=False)
sorted_users1=sorted_users1[:120]
sorted_users1
Data2=Data[Data.User_Id.isin(sorted_users1.index)]
Data2['Place_Rating'].value_counts().sort_index().plot(kind='bar')
plt.xlabel('Place Rating')
plt.ylabel('Count')
plt.title('Count of Place Ratings')
plt.show()
Data2.groupby('Place_Id')['Place_Rating'].mean().head()
Data2.groupby('User_Id')['Place_Rating'].mean().head()
Data2.groupby('User_Id')['Place_Rating'].mean().sort_values(ascending=False)
Data2.count()
Data3=Dataset.load_from_df(Data2[['User_Id', 'Place_Id', 'Place_Rating']], reader)
trainset, testset = train_test_split(Data3, test_size=0.3)
reader= Reader(rating_scale=(1.0, 5.0))
algo = SVD()
algo.fit(trainset)
predictions2=algo.test(testset)
predictions2
accuracy.mae(predictions2, verbose=True)
accuracy.mse(predictions2, verbose=True)
accuracy.rmse(predictions2, verbose=True)
accuracy.fcp(predictions2, verbose=True)
def get_top_n(predictions, n=5):
    # First map the predictions to each user.
    top_n = defaultdict(list)
    for uid, iid, true_r, est, _ in predictions:
        top_n[uid].append((iid, est))

    # Then sort the predictions for each user and retrieve the k highest ones.
    for uid, user_ratings in top_n.items():
        user_ratings.sort(key=lambda x: x[1], reverse=True)
        top_n[uid] = user_ratings[:n]

    return top_n
top_5s = get_top_n(predictions2, n=5)
top_5s
top_5s['']
"""