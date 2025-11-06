import datetime, json
data = {"timestamp": str(datetime.datetime.now()), "cpu": 30, "memory": 200}
with open("daily_report.json","w") as f: json.dump(data,f,indent=4)
print("Report generated")
