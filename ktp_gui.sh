#!/bin/bash
date_start=2024-09-01
date_end=2025-05-28
TXT=kanikuls_gui.txt
TXT1=holiday_gui.txt
TXT2=date.txt
TXT3=date_osn.csv
HOL=()
KANIKUL_OSN=(2024-10-28 2024-10-29 2024-10-30 2024-10-31 2024-11-01 2024-11-02 2024-11-03 2024-12-30 2024-12-31 2025-01-01 2025-01-02 2025-01-03 2025-01-04 2025-01-05 2025-01-06 2025-01-07 2025-01-08 2025-03-24 2025-03-25 2025-03-26 2025-03-27 2025-03-28 2025-03-29 2025-03-30)
KANIKUL_DOP=(2024-10-28 2024-10-29 2024-10-30 2024-10-31 2024-11-01 2024-11-02 2024-11-03 2024-12-30 2024-12-31 2025-01-01 2025-01-02 2025-01-03 2025-01-04 2025-01-05 2025-01-06 2025-01-07 2025-01-08 2025-02-17 2025-02-18 2025-02-19 2025-02-20 2025-02-21 2025-02-22 2025-02-23 2025-03-24 2025-03-25 2025-03-26 2025-03-27 2025-03-28 2025-03-29 2025-03-30)
KANIKULS=()
HOLIDAY=(2024-10-04 2025-02-24 2025-03-10 2025-05-01 2025-05-02 2025-05-09)
DATE=()
LESS=()
KANIK=(осенних зимних дополнительных весенних)

# Провекрка выходных
if [[ -z "$TXT1" ]]; then
  for i in "${!HOLIDAY[@]}";
  do
    HOL+=( "${HOLIDAY[$i]}" )
  done
  printf "%s\n" "${HOL[@]}" > $TXT1
fi

function hello () {
  zenity --question \
  --title="Даты для КТП" \
  --text="Добро пожаловать\nТут вы быстро настроите даты для КТП\nВы преподаете в 1-х классах?"
  case $? in
      0)
          ktp_dop
    ;;
      1)
          ktp
    ;;
      -1)
          echo "An unexpected error has occurred."
    ;;
  esac
}

function lesson () {
  printf "%s\n" "${KANIKULS[@]}" >> $TXT
  lesson=$(zenity --forms --title="Введите кол-во уроков" \
          --text="Если урока нет напишите \"0\"" \
          --separator="," \
          --add-entry="Понедельник" \
          --add-entry="Вторник" \
          --add-entry="Среда" \
          --add-entry="Четверг" \
          --add-entry="Пятница")
  LESS+=("$( echo "$lesson" | awk -F ',' '{print $1}' )")
  LESS+=("$( echo "$lesson" | awk -F ',' '{print $2}' )")
  LESS+=("$( echo "$lesson" | awk -F ',' '{print $3}' )")
  LESS+=("$( echo "$lesson" | awk -F ',' '{print $4}' )")
  LESS+=("$( echo "$lesson" | awk -F ',' '{print $5}' )")
      # shellcheck disable=SC2236
      if [[ ! -z "$TXT2" ]]; then
        rm -rf "$TXT2"
      fi
      # shellcheck disable=SC2236
      if [[ ! -z "$TXT3" ]]; then
        rm -rf "$TXT3"
      fi
  case $? in
      0)
      progress
    ;;
      1)
          exit
    ;;
      -1)
          echo "An unexpected error has occurred."
    ;;
  esac
}

function holliday_dop ()
{
  holliday=$(zenity --forms --title="Даты для КТП" \
      --separator="," \
      --add-calendar="выберите начало $1 каникул" \
      --forms-date-format %Y-%m-%d \
      --add-calendar="выберите конец $1 каникул" \
      --forms-date-format %Y-%m-%d);
  start=$( echo $holliday | awk -F ',' '{print $1}' )
  end=$( echo $holliday | awk -F ',' '{print $2}' )
    while [[ $start != $end ]];
    do
      KANIKULS+=("$(date -d "$start" +%F)")
      start=$(date -d "$start +1 day" +%F)
    done
  KANIKULS+=("$(date -d "$end" +%F)")
}

function holliday ()
{
  holliday=$(zenity --forms --title="Даты для КТП" \
      --separator="," \
      --add-calendar="выберите начало $1 каникул" \
      --forms-date-format %Y-%m-%d \
      --add-calendar="выберите конец $1 каникул" \
      --forms-date-format %Y-%m-%d);
  start=$( echo "$holliday" | awk -F ',' '{print $1}' )
  end=$( echo "$holliday" | awk -F ',' '{print $2}' )
    while [[ $start != "$end" ]];
    do
      KANIKULS+=("$(date -d "$start" +%F)")
      start=$(date -d "$start +1 day" +%F)
    done
  KANIKULS+=("$(date -d "$end" +%F)")

}

function ktp_dop {
  zenity --question \
  --title="Проверьте даты каниул, и сверьте с вашими" \
  --text="Осенние каникулы с 28.10.2024 по 03.11.2024\n\nЗимние каникулы с 30.12.2024 по 08.01.2025\n\nДополнительные зимние каникулы (Для первоклассников) с 17.02.2025 по 23.02.2025\n\nВесенние каникулы 24.03.2025 по 30.03.2025\n\nВсё верно?"
  case $? in
      0)
          # shellcheck disable=SC2236
          if [[ ! -z "$TXT" ]]; then
            rm -rf "$TXT"
            printf "%s\n" "${KANIKUL_DOP[@]}" > $TXT
          fi
          lesson_dop
    ;;
      1)
          rm -rf "$TXT"
          holliday "${KANIK[0]}"
          holliday "${KANIK[1]}"
          holliday "${KANIK[2]}"
          holliday "${KANIK[3]}"
          lesson_dop
    ;;
      -1)
          echo "An unexpected error has occurred."
    ;;
  esac
}

function ktp {
  zenity --question \
  --title="Проверьте даты каниул, и сверьте с вашими" \
  --text="Осенние каникулы с 28.10.2024 по 03.11.2024\n\nЗимние каникулы с 30.12.2024 по 08.01.2025\n\nВесенние каникулы 24.03.2025 по 30.03.2025\n\nВсё верно?"
  case $? in
      0)
          # shellcheck disable=SC2236
          if [[ ! -z "$TXT" ]]; then
            rm -rf "$TXT"
            printf "%s\n" "${KANIKUL_OSN[@]}" > $TXT
          fi
          lesson
    ;;
      1)
          rm -rf "$TXT"
          holliday "${KANIK[0]}"
          holliday "${KANIK[1]}"
          holliday "${KANIK[3]}"
          lesson
    ;;
      -1)
          echo "An unexpected error has occurred."
    ;;
  esac
}

function progress() {
# выводим все дни в году
  day=0
  for item in "${LESS[@]}"; do
    case $item in
      1 | 2 | 3 | 4 | 5 )
          date_start=2024-09-01
          date_end=2025-05-28

          echo
          NAME_DAY=(Понедельник Вторник Среда Четверг Пятница)
          # shellcheck disable=SC2046
          while [ $(date --date="$date_start" +%A) != "${NAME_DAY[$day]}" ]; do
            date_start=$(date -I -d "$date_start  + 1 day")
          done
          until [[ $date_start > $date_end ]]; do
            for((i=0;i<$item;i++)); do
              DATE+=( "$date_start" )
            done
            date_start=$(date -I -d "$date_start  + 1 week")
          done
          echo "${NAME_DAY[$day]}"
          # shellcheck disable=SC2046
          if [ $(date --date="$date_start" +%A) == "Понедельник" ]; then
            DATE+=( "2024-12-28" )
            DATE+=( "2025-05-27" )
          fi
          # shellcheck disable=SC2046
          if [ $(date --date="$date_start" +%A) == "Вторник" ]; then
            delete=2025-05-27
            DATE=("${DATE[@]/$delete}")

          fi
          # shellcheck disable=SC2046
          if [ $(date --date="$date_start" +%A) == "Среда" ]; then
            delete=2025-05-28
            DATE=("${DATE[@]/$delete}")
          fi
          # shellcheck disable=SC2046
          if [ $(date --date="$date_start" +%A) == "Пятница" ]; then
            DATE+=( "2024-10-26" )
            DATE+=( "2025-05-28" )
          fi
          (( day+=1 ))
        ;;
      *)
        echo "Пусто"
        (( day+=1 ))
        ;;
    esac
  done
# Делаем файлики
  printf "%s\n" "${DATE[@]}" | sort > $TXT2
  cat $TXT1 >> $TXT
  grep -vxFf $TXT $TXT2 > data.tmp

  # shellcheck disable=SC2162
  while read line
    do
      # shellcheck disable=SC2046
      # shellcheck disable=SC2005
      echo $(date --date="$line" +%d.%m.%Y) | paste -sd " " >> $TXT3
    done < data.tmp

# Окно вывода
    zenity --question \
      --title="Все готово" \
      --text="НАПОМИНАНИЕ\n27.05.2024  и 28.05.2025 года \nзанятия проводятся по  расписанию\n понедельника и пятницы!\n\nОткрыть файл?"
    case $? in
          0)
          libreoffice $TXT3
        ;;
          1)
            exit
        ;;
          -1)
              echo "An unexpected error has occurred."
        ;;
    esac

}

hello
