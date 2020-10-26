from bs4 import BeautifulSoup as bs
import requests
import re

"""

CHOO SANGBUEM
71675619
Some Norwegian characters don't work but overall this works.


"""

def output_results(soup):
    match_data_list = []
    match_data = soup.find_all(class_='schedule__match__item--teams')
    # print(match_data)
    for r in match_data:
        row_data = list(r.strings)
        match_data_list.append(row_data)

    print("first one in the match_data_list")
    print(match_data_list[0])
    # returns ['\n', 'S', '\r\n\r\n\t\t\t\t\t\tHaugesund-', 'Sandefjord Fotball', '\n', '(4-2)', '\n']

    f = open('soccer_stat.csv','w')
    f.write('R, Home, Away, Score \n') #Give your csv text here.
    for line in match_data_list:
        #just get index 1, 2, 3, 5
        templist = []
        templist.append(line[1])
        templist.append(line[2])
        templist.append(line[3])
        templist.append(line[5])
        line = templist.copy()

        print("Get relevant indexes")
        print(line)
        # returns ['S', '\r\n\r\n\t\t\t\t\t\tHaugesund-', 'Sandefjord Fotball', '(4-2)']

        #remove special characters using regex 
        line[1] = re.findall(r'\w+', line[1])[0] #findall returns a list so use [0] index at the end to add only the element
        # pick '\r\n\r\n\t\t\t\t\t\tHaugesund-' and remove special characters

        print("After")
        print(line)
        # returns ['S', 'Haugesund', 'Sandefjord Fotball', '(4-2)']

        for item in line:
            if item == line[-1]:
                f.write(item)
            else:
                f.write(item + ", ")
        f.write("\n")

    f.close()



page = requests.get('http://www.fkh.no/resultater')
soup = bs(page.text, 'html.parser')

#output to csv file
output_results(soup) 







