"""
Parse WER and other metadata from Languagepack emails and organize them into
a csv file.

Instructions:
1. In gmail, search/filter each experiment's emails (should be 15 for 15 languages)
2. Select all, more -> forward as attachment, give descriptive name, send
3. Open email and save zip file of all attachments into downloads
4. In terminal, run `python parse_wer.py name1 [name2] [name3] ...`
5. Results will be placed in parse_wer.csv in downloads
6. Optional: import to sheets. Select cell, import, tab delimiter, insert at cell
"""

import os
import re
import sys

def unzip_get_filelist(zipfile):
  directory = zipfile.replace('.zip', '')
  os.system('rm -r ' + directory)
  os.system('unzip -qq ' + zipfile + ' -d ' + directory)
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

def regex_model(content):
  pattern = r'Engine dir: /cns/' \
            r'.+?' \
            r'/wrh_\w+?_(\w+?)_\d{10}/' \
            r'\w+?/' \
            r'(\d{8})<br>' \
            r'.*Eval root dir'
  match = re.search(pattern, content, re.DOTALL)
  modelname, modeliter = match.group(1), match.group(2)
  return modelname, modeliter

def sort_filelist_by_lang(files):
  languages = 'en_us, en_in, ar_eg, ar_x_gulf, hi_in, mr_in, bn_bd, es_es, es_us, pt_br, hu_hu, ms_my, ru_ru, tr_tr, cmn_hant_tw'
  languages = languages.replace('_', '')
  languages = languages.replace(' ', '')
  languages = languages.split(',')
  sortedfiles = []
  for lang in languages:
    sortedfiles.append(None)
    for file in files:
      if lang in file:
        sortedfiles.pop()
        sortedfiles.append(file)
        break
  return sortedfiles

def sort_filelist_by_expt(allfiles):
  def _get_modelinfo(filename):
    st = filename.find("'")
    filename = filename[st + 1:]
    ed = filename.find("'")
    filename = filename[:ed]
    filename = filename.split('_')
    modelinfo = (filename[3], filename[-1])
    return modelinfo

  allfiles.sort(key=_get_modelinfo)

  outfiles = []
  for i, file in enumerate(allfiles):
    modelinfo = _get_modelinfo(file)
    if not outfiles:
      current = modelinfo
    if modelinfo != current:
      yield outfiles
      current = modelinfo
      outfiles = []
    outfiles.append(file)
  yield outfiles

if __name__ == '__main__':

  # Combine all zipfiles
  home = os.environ['HOME']
  rootdir = os.path.join(home, 'Downloads')
  _zipfiles = sys.argv[1:]
  allfiles = []
  for _zipfile in _zipfiles:
    zipfile = os.path.join(rootdir, _zipfile + '.zip')
    allfiles.extend(unzip_get_filelist(zipfile))
  print(f'{len(allfiles)} files found')

  # Parse all files
  with open(os.path.join(rootdir, 'parse_wer.csv'), 'w') as outfile:
    for per_expt_files in sort_filelist_by_expt(allfiles):
      files = sort_filelist_by_lang(per_expt_files)
      entries = []
      first = True
      for file in files:
        cnt += 1
        if file is None or 'failed' in file:
          entries.append('n/a')
          continue
        with open(file, 'r') as f:
          content = f.read()
          content = clean_content(content)
          result = regex_result(content)
          link = regex_link(content)
          if first:
            first = False
            modelname, modeliter = regex_model(content)
            entries = [modelname, modeliter] + entries
          entries.append('=HYPERLINK("' + link + '", "' + result + '")')
      outfile.write('\t'.join(entries) + '\n')
  os.system('open ' + rootdir)



