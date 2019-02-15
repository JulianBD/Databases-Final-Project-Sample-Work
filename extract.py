import csv
import requests
import json

data = []

with open('billboard_lyrics_1964-2015.csv', mode='r') as csv_file:
        csvDict = csv.DictReader(csv_file)
        for line in csvDict:
            data.append(line)
            #song = line["Song"].replace(" ","+")
            #artist = line["Artist"].replace(" ","+")
            #url = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=ab7a0648a76c53a31e758a7590c777f7&artist={}&track={}&format=json"
            #url = url.format(artist, song)
            #request = requests.get(url)
            #print("TRACK %s" % line["Song"])
            #if request.status_code == 200:
                #obj = json.loads(request.text)
                #dest = obj["track"]
                #if 'album' not in dest:
                   # print("NO ALBUM")
                #else:
                    #print(obj["track"]["album"]["title"])
                    #csv[""]append(obj["track"]["album"]["title"])

#print(data)

for line in data:
    song = line["Song"].replace(" ","+")
    artist = line["Artist"].replace(" ","+")
    url = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=ab7a0648a76c53a31e758a7590c777f7&artist={}&track={}&format=json"
    url = url.format(artist, song)
    request = requests.get(url)
    #print("TRACK %s" % line["Song"])
    if request.status_code == 200:
        obj = json.loads(request.text)
        if 'track' not in obj:
            continue
        elif 'album' not in obj["track"]:
                #print("NO ALBUM")
                line["Album"] = "NO ALBUM"
                continue
        else:
            #print(obj["track"]["album"]["title"])
            #print(str(line["Song"]) + " - " + str(obj["track"]["album"]["title"]).encode("utf-8"))
            try:
                print(str(line["Song"]) + " - " + str(obj["track"]["album"]["title"]).encode("utf-8"))
                line["Album"] = str(obj["track"]["album"]["title"]).decode("utf-8")
            except:
                UnicodeEncodeError
                UnicodeDecodeError
                continue
            
            #print(line)

with open('data_file.csv', 'w') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=["Rank", "Song", "Artist", "Year", "Lyrics", "Source", "Album"])
            writer.writeheader()
            for line in data:
                try:
                    writer.writerow({"Rank":line["Rank"], "Song":line["Song"], "Artist":line["Artist"], "Year":line["Year"], "Lyrics":line["Lyrics"], "Source":line["Source"], "Album":line["Album"]})
                except:
                    KeyError
                    UnicodeEncodeError
                    UnicodeDecodeError
                    continue

