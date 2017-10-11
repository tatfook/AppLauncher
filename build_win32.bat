rem author: lixizhi@yeah.net
rem date: 2017.10.11
rem desc: Install dependencies: (currently only BOOST, cmake 3.2 and DirectX9 SDK)
rem guide: add `BOOST_ROOT` to environment variable, such as 'D:\lxzsrc\NPLRuntime\Server\trunk\boost_1_60_0', 
rem        make sure to prebuilt your boost library with `b2 runtime-link=static --with-thread --with-date_time --with-filesystem --with-system --with-chrono --with-signals --with-serialization --with-iostreams --with-regex stage`
  
pushd .
mkdir bin
cd bin
call cmake ../
popd