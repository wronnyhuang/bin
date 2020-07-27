import os
import re
import sys

def unzip_get_filelist(zipfile):
  directory = zipfile.replace('.zip', '')
  os.system('rm -r ' + directory)
  os.system('unzip ' + zipfile + ' -d ' + directory)
  return [os.path.join(directory, f) for f in os.listdir(directory)]

def clean_content(content):
  content = content.replace('=', '')
  content = content.replace('\n', '')
  content = content.replace('\r', '')
  return content

def regex_link(content):
  pattern = r'To share these results or look at them on an HTML page, go see <a href' \
            r'.*?' \
            r'"(http://utt-viewer.corp.google.com/.+?custom.html)"' \
            r'.*?' \
            r'custom\.html'
  match = re.search(pattern, content, re.DOTALL)
  return match.group(1)

def regex_result(content):
  pattern = r'Primary quality metrics' \
            r'.+?' \
            r'/PRODUCTION/AH_MOBILE_.+?' \
            r'>T\s([\d.]+)\s(\([\d./]+?\))' \
            r'.+?' \
            r'</table>'
  match = re.search(pattern, content, re.DOTALL)
  ret = match.group(1)
  # ret = ret + ' ' + match.group(2)
  return ret

def sort_filelist(files):
  languages = 'en_us, en_in, ar_eg, ar_x_gulf, hi_in, mr_in, bn_bd, es_es, es_us, pt_br, hu_hu, ms_my, ru_ru, tr_tr, cmn_hant_tw'
  languages = languages.replace('_', '')
  languages = languages.replace(' ', '')
  languages = languages.split(',')
  sortedfiles = []
  for lang in languages:
    for file in files:
      if lang in file:
        sortedfiles.append(file)
        break
  return sortedfiles

if __name__ == '__main__':

  names = sys.argv[1:]
  home = os.environ['HOME']
  rootdir = os.path.join(home, 'Downloads')
  for name in names:
    zipfile = os.path.join(rootdir, name + '.zip')
    files = unzip_get_filelist(zipfile)
    files = sort_filelist(files)
    entries = []
    for file in files:
      with open(file, 'r') as f:
        content = f.read()
        content = clean_content(content)
        result = regex_result(content)
        link = regex_link(content)
        entries.append('=HYPERLINK("' + link + '", "' + result + '")')
    with open(os.path.join(rootdir, name + '.csv'), 'w') as f:
      f.write('\t'.join(entries))
  os.system('open ' + rootdir)



