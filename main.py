from flask import Flask, jsonify
from models import Db_query

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config['JSON_SORT_KEYS'] = False


query=Db_query('database/animal.db')


@app.route("/<item>")
def page_item(item):
    return jsonify(query.get_item(item))


if __name__ == '__main__':
    app.run('127.0.0.1', 8000)
