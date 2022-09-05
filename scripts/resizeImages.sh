pushd ~/DayLog/public/pics
rm -rf attractive
rm -rf motivating
cp -r attractive_SRC attractive
cp -r motivating_SRC motivating

pushd attractive
mogrify -resize '1280x1024>' *.jpg
popd

pushd motivating
mogrify -resize '1280x1024>' *.jpg
popd

popd
