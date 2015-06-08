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
            contents: "
module.exports = function(grunt){
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        sass:{
            dev:{
                options:{
                    outputStyle:'expanded'
                },
                files:{
                    'css/styles.css' : 'src/scss/application.scss'
                }
            }
        },
        watch:{
            js:{
                files:['src/js/*.js'],
                tasks:['uglify:dev']
            },
            css:{
                files:['src/scss/*.scss'],
                tasks:['sass:dev']
            },
        },
        uglify: {
            options: {
                sourceMap: true
            },
            dev:{
                options:{
                    beautify: true,
                    mangle: false,
                    compress: false
                },
                files: {
                    'js/app.min.js': ['src/js/vendor/*.js', 'src/js/*.js']
                }
            },
            build: {
                files: {
                    'js/app.min.js': ['src/js/vendor/*.js', 'src/js/*.js']
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-sass');

    grunt.registerTask('default',['uglify:build']);
    grunt.registerTask('dev',['uglify:dev', 'sass:dev']);

};
"
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
        },
        {
            name:'package.json',
            type:'file',
            path: project+'/',
            contents: '
{
  "name": "'+input+'",
  "version": "0.0.1",
  "description": "",
  "main": "index.html",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "grunt": "^0.4.5",
    "grunt-contrib-uglify": "^0.9.1",
    "grunt-contrib-watch": "^0.6.1",
    "grunt-sass": "^1.0.0"
  }
}
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


fs.each do |f|
    build_fs_for(f)
end
