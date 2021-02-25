INPUT_NUM=50

INPUT_DIR="input/"
OUTPUT_DIR="output/"
SCORE_DIR="score/"
GENERATOR_NAME="generator"
SOLVER_NAME="solver"
TESTER_NAME="tester"

JOB_NUM=4

job_start () {
  local max_jobn=$1
  while [[ "$(jobs | wc -l)" -ge "$JOB_NUM" ]] ; do
    sleep 0
  done
}


BUILD="docker run --rm -v $PWD:/src -w /src dlang2/dmd-ubuntu:2.091.0 dmd -wi -m64 -O -release -inline -boundscheck=off "
DEBUG="docker run --rm -v $PWD:/src -w /src dlang2/dmd-ubuntu:2.091.0 dmd -g -debug "

if [ "$1" = "debug" ]; then
    COMPILE="$DEBUG"
    PARALLEL="n"
else
    COMPILE="$BUILD"
    PARALLEL="y"
fi

parallel() {
    if [ "$PARALLEL" = "y" ]; then
        $@ &
    else
        $@
    fi
}

echo "Removing old files..."
rm -rf ${INPUT_DIR} ${OUTPUT_DIR} ${GENERATOR_NAME} "${GENERATOR_NAME}.o" ${SOLVER_NAME} "${SOLVER_NAME}.o"

echo "Building generator..."
parallel ${COMPILE} "${GENERATOR_NAME}.d"
if [ ! $? = 0 ]; then
    echo "Build failed."
    exit
fi

echo "Building solver..."
parallel ${COMPILE} "${SOLVER_NAME}.d"
if [ ! $? = 0 ]; then
    echo "Build failed."
    exit
fi

echo "Building tester..."
parallel ${COMPILE} "${TESTER_NAME}.d"
if [ ! $? = 0 ]; then
    echo "Build failed."
    exit
fi

wait

generate(){
    timeout 3 ./${GENERATOR_NAME} ${1} > "${INPUT_DIR}/${1}.txt"
}
echo -n "Generateing Input..."
mkdir -p ${INPUT_DIR}
for i in $(seq 1 ${INPUT_NUM}); do
    job_start
    parallel generate $i
    echo -n "."
done
wait
echo

execute() {
    timeout 3 ./${SOLVER_NAME} ${1} < "${INPUT_DIR}/${1}.txt" > "${OUTPUT_DIR}/${1}.txt"
}
echo -n "Executing..."
mkdir -p ${OUTPUT_DIR}
for i in $(seq 1 ${INPUT_NUM}); do
    job_start
    parallel execute ${i}
    echo -n "."
done
wait
echo


test() {
    local file=$(mktemp)
    cat "${INPUT_DIR}/${1}.txt" "${OUTPUT_DIR}/${1}.txt" > ${file}
    timeout 3 ./${TESTER_NAME} ${1} < ${file} > "${SCORE_DIR}/${1}.txt"
    rm ${file}
}
echo -n "Testing..."
mkdir -p ${SCORE_DIR}
for i in $(seq 1 ${INPUT_NUM}); do
    job_start
    parallel test ${i}
    echo -n "."
done
wait
echo

SCORES=()
SUM=0
for i in $(seq 1 ${INPUT_NUM}); do
    SCORE=$(cat "${SCORE_DIR}/${i}.txt")
    SCORES+=( ${SCORE} )
    SUM=$(( SUM + SCORE ))
done
AVG=$(echo "$SUM / $INPUT_NUM" | bc -l)
echo ${SCORES[@]}

echo
echo "    Sum: ${SUM}"
echo "    Avg: ${AVG}"
echo