require 'pry'
require 'fileutils'
print "Project Name: "
input = gets.strip
project = './'+input
js = project+'/js'
css = project+'/css'
src = project+'/src'
fs = [
        {
            name: 'js',
            type:'folder',
            path: js,
            contents: []
        },
        {
            name: 'css',
            type:'folder',
            path: css,
            contents: []
        },
        {
            name: 'src',
            type:'folder',
            path: src,
            contents:
            [
                {
                    name: 'js',
                    type:'folder',
                    path: src+'/js',
                    contents:[
                        {
                            name: 'vendor',
                            type:'folder',
                            path: src+'/js/vendor',
                            contents:[]
                        },
                        {
                            name: 'app.js',
                            type:'file',
                            path: src+'/js/',
                            contents: ''
                        }
                    ]

                }
            ]
        },
        {
            name: 'gruntfile.js',
            type:'file',
            path: project+'/',
            contents: ''
        },
        {
            name: 'index.html',
            type:'file',
            path: project+'/',
            contents: '
<!DOCTYPE html>
    <html>
        <head>
            <title>'+input+'</title>
            <link rel="stylesheet" type="text/css" href="./css/styles.css">
        </head>
        <body>
            <script src="./js/app.min.js"></script>
        </body>
    </html>
'
        }

]


def build_fs_for(f)
    if f[:type] == 'folder'
        system 'mkdir', '-p', f[:path]
        f[:contents].each do |ff|
            build_fs_for(ff)
        end
    end
    if f[:type] == 'file'
        File.open(f[:path]+f[:name], 'w'){|file| file.write(f[:contents])}
    end
end

# system 'mkdir', '-p', project
# system 'mkdir', '-p', project+'/js'



fs.each do |f|
    build_fs_for(f)
end
