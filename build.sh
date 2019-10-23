#!/bin/sh

newVersion="0"

function show_help()
{
echo "$0 运行脚本 打包更新pod并提交"
echo "\t默认版本号自动加1"
echo "\t-v 1.2.3 手动指定版本号 1.2.3"
}

until [ $# -eq 0 ]
do
case "$1" in
-h|--help) show_help $0
exit 0;;
-v) newVersion=$2
shift 2;;
*) echo "参数异常"
show_help $0
exit 0;;
esac
done

echo "git提交测试"
git push origin
if [[ $? -ne 0 ]]; then
echo "请先进行合并提交，才可以进行打包！"
exit -1
fi

echo "####################### 开始打包！！ "
PROJECT_ROOT=$(pwd)
TARGET="CDAdditions"
PROJECT="$PROJECT_ROOT/$TARGET.xcodeproj"
ARCH="Release"

rm -rf $PROJECT_ROOT/$TARGET.framework
rm -rf "$PROJECT_ROOT/build"
echo "####################### 打包模拟器 "
xcodebuild -project $PROJECT -target $TARGET -sdk iphonesimulator -configuration $ARCH clean build
if [[ $? -ne 0 ]]; then
exit -1
fi

cp -R $PROJECT_ROOT/build/Release-iphonesimulator/$TARGET.framework $PROJECT_ROOT/$TARGET.framework
echo "####################### 打包真机 "
xcodebuild -project $PROJECT -target $TARGET -sdk iphoneos -configuration $ARCH clean build
if [[ $? -ne 0 ]]; then
exit -1
fi
echo "####################### 合成 fat "
lipo -create $PROJECT_ROOT/build/Release-iphoneos/$TARGET.framework/$TARGET $PROJECT_ROOT/$TARGET.framework/$TARGET -output $PROJECT_ROOT/$TARGET.framework/$TARGET
if [[ $? -ne 0 ]]; then
exit -1
fi
rm -Rf "$PROJECT_ROOT/build"


echo "####################### 更新CDAdditions"

commitInfo="source commit:  "`git rev-parse HEAD`

git pull
if [[ $? -ne 0 ]]; then
exit -1
fi
#rm -rf Resources
#cp -R ../Resources Resources
#rm -rf $TARGET.framework
#cp -R ../$TARGET.framework $TARGET.framework

version=`ruby -e 'puts /[\s]*[\w]+\.version[\s]*=[\s]*\"([\w\.\-]*)\"/.match(File.read "./CDAdditions.podspec")[1]'`
if [[ $? -ne 0 ]]; then
exit -1
fi
echo "####################### old version is $version"
if [[ $newVersion == "0" ]]
then
newVersion=`ruby -e "splits=\"$version\".split('.');subversion=splits[3].to_i + 1;puts splits[0]+'.'+splits[1]+'.'+splits[2]+'.'+subversion.to_s"`
if [[ $? -ne 0 ]]; then
exit -1
fi
fi
echo "####################### new version is $newVersion"

if [ `git tag | grep $newVersion` ];then
echo "####################### 当前版本已存在，请进行检测！！！"
exit 1
fi
echo "####################### 更新podspec 文件"
sed -i "" "s/$version/$newVersion/g" "CDAdditions.podspec"

commitInfo=$newVersion"  ||  "$commitInfo
echo "####################### git 提交 ： $commitInfo"
git add .
git commit -m "$commitInfo"
git push
if [[ $? -ne 0 ]]; then
exit -1
fi
git tag "$newVersion"
git push origin "$newVersion"
if [[ $? -ne 0 ]]; then
exit -1
fi
echo "####################### pod trunk push "
pod trunk push --allow-warnings
if [[ $? -ne 0 ]]; then
exit -1
fi
echo "####################### 打包完成! "

