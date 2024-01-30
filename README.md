# Final Project

iOS final project: Calcudoku Pro Max.

演示视频：https://www.bilibili.com/video/BV1m64y1w7Hw

##### 功能简介

- 编写了两个 Python 脚本，fetch.py 用于题目 PDF 爬取并拆分为 PNG 格式的图片，construct.py 用于分析题目图片并导出为 JSON 格式
- 合并了 iwork2 和 iwork3 的工作，其中题目界面改为在读取题目 JSON 后动态生成，可以显示不同尺寸的题目

##### 偷懒

- 每个 book 只取用了第一个题目，剩余题目没有载入应用
- 5\*5 和 6\*6 仅实现了 beginner vol1 book1 这一个 book，原因后续会提到

##### fetch.py

考虑到题目非常多，因此每个 Volume 仅爬取了 20 个 Book 。

使用了 fitz 包处理 PDF 。

##### construct.py

该脚本主要分为两个部分：边缘检测和 OCR 识别

仔细分析题目图片后发现，用于区分 group 的粗边缘都有颜色为 #000000 的部分，而用于区分 cell 的细边缘没有，而且各图片格式高度一致，cell 宽度也一致。因此采用了比较原始的边缘检测方案，直接获取每处边缘的像素，如果颜色为 #000000 ，则两侧的 cell 分属两个 group 。

OCR 识别使用了 pytesseract 包，截取每个图片中 cell 可能存在文本的区域进行识别。但是实践后发现，此处 OCR 识别对于短文本的识别精度不高，4\*4 的仅少部分识别结果有误，但对于 5\*5 和 6\*6 则完全无法正确扫描一整道题目，因此  5\*5 和 6\*6 的 JSON 文件分别手动编写了一个用于后续展示。

##### Swift 部分

做题界面的逻辑和分类界面已在先前的作业中完成，这次的主要工作在于动态化生成做题界面。感觉 StoryBoard 这套 UI 框架的尺寸控制略有些反直觉，中间遇到过多处编程控制尺寸失效的问题，最后是通过禁用 `translatesAutoresizingMaskIntoConstraints` 属性解决的。
