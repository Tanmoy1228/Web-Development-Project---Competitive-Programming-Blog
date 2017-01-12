﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Segment_Tree_2.aspx.cs" Inherits="Segment_Tree_2" %>

<!DOCTYPE html>

<html >
<head runat="server">
    <title>Segment Tree-2</title>
    <link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>
    <form runat="server">
 	<div class="main">

 		<div class="header">
 			<img src="image/cover.jpg"/>
 		</div>

 		<div class="mainmenu">
            <div class="menubar">
 			<ul>
 				<li><a href="Home.aspx">Home</a></li>
 				<li><a href="About_Me.aspx">About Me</a></li>
 				<li><a href="Programming_content.aspx">Programming Content</a></li>
 				<li><a href="other.aspx">Others</a></li>
 			</ul>
            </div>
             <div class="logout">
                 <ul>
                 <li><a href="Logout.aspx">Logout</a></li>
                 </ul>
             </div>
 		</div>
         <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:BlogConnectionString %>" SelectCommand="SELECT * FROM [commentTable] WHERE ([postID] =@postID)">
             <SelectParameters>
                 <asp:Parameter DefaultValue="segment2" Name="postID" Type="String" />
             </SelectParameters>
        </asp:SqlDataSource>
 		<div class="maincontent">
             <div class="content">
 			<div class="posthead">
 				<h1>
<li><a href="Segment_Tree_2.aspx">ডাটা স্ট্রাকচার: সেগমেন্ট ট্রি-২ (লেজি প্রপাগেশন)</a> </li></h1></div>
<div class="post">লেখক: শাফায়েত, তারিখ: জুলাই ১৮, ২০১৩

<pre>
    <p>

সেগমেন্ট ট্রির সবথেকে এলিগেন্ট অংশ হলো লেজি প্রপাগেশন টেকনিক। আমরা<a href="Segment_Tree_1.aspx"> আগের পর্বে</a> যে সেগমেন্ট ট্রি যেভাবে আপডেট 
        
করেছি তাতে একটা বড় সমস্যা ছিলো। আমরা একটা নির্দিষ্ট ইনডেক্স আপডেট করতে পেরেছি, কিন্তু একটা রেঞ্জের মধ্যে সবগুলো
        
ইনডেক্স আপডেট করতে গেলেই বিপদে পরে যাবো। সে কারণেই আমাদের লেজি প্রপাগেশন শিখতে হবে, প্রায় সব সেগমেন্ট ট্রি 
        
প্রবলেমেই এই টেকনিকটা কাজে লাগবে। এই পর্বটা পড়ার আগে অবশ্যই তোমাকে সেগমেন্ট ট্রির একদুটি প্রবলেম সলভ করে 
        
আসতে হবে, এছাড়া তোমার বুঝতে সমস্যা হবে।<a href="Segment_Tree_1.aspx"> আগের পর্বে</a> লেজি প্রপাগেশন দরকার হয়না এমন কয়েকটি প্রবলেম দিয়েছি, 
     
আগে সেগুলো সলভ করতে হবে।


তোমাকে একটি অ্যারে দেয়া আছে n সাইজের এবং তোমাকে কুয়েরি করা হচ্ছে i থেকে j ইনডেক্সের মধ্যে সবগুলো এলিমেন্টের 
        
যোগফল বলতে হবে। আর আপডেট অপারেশনে তোমাকে বলা হলো i থেকে j ইনডেক্সের মধ্যে সবগুলো সংখ্যার সাথে একটি 
        
নির্দিষ্ট সংখ্যা x যোগ করতে।


যেমন যদি অ্যারেটা শুরুতে হয়তো ছিলো এরকম:


4 1 2 3 9 8 7


তাহলে i=3,j=5 ইনডেক্সের মধ্যে সবগুলো সংখ্যার সাথে ২ যোগ করলে অ্যারেটা হবে:


4 1 2+2 3+2 9+2 8 7


আবার i=3,j=4 ইনডেক্সের মধ্যে সবগুলো সংখ্যার যোগফল হবে ২+২+৩+২=৯।


আগের প্রবলেমে আমরা খালি একটা ইনডেক্স আপডেট করেছিলাম। তখন আমি শুধু ৩ নম্বর ইনডেক্সে আপডেট দেখানোর জন্য 
        
এই ছবিটা একেছিলাম:

<img src="image/seg_2/1.jpg"/>


আমরা সেগমেন্ট ট্রি এর একদম নিচে গিয়ে ৩ যেখানে আছে সেই নোডটা আপডেট করেছি এবং সেই পথের বাকিনোডগুলোকেও 
        
আপডেট করে দিয়েছি উপরে ওঠার সময়।


এখন তোমাকে i=১ এবং j=৪ এই রেঞ্জের সবার সাথে x যোগ করতে বলা হলো। একটা সলিউশন হতে পারে তুমি আগের মতো 
        
করেই ১,২,৩,৪ ইত্যাদি ইনডেক্স আলাদা করে আপডেট করলে। তাহলে প্রতি আপডেটে কমপ্লেক্সিটি logn এবং সর্বোচ্চ n টি 
        
আপডেটের জন্য nlogn সময় লাগবে। এটা খুব একটা ভালো সলিউশন না, আমরা এখানে logn এই আপডেট করতে পারি।


কিছু ডেফিনেশন:

যেকোনো ট্রি স্ট্রাকচারে লিফ নোড হলো সবথেকে নিচের নোডগুলো। লিফ ছাড়া বাকি সবনোড হলো ইন্টারনাল নোড।

সেগমেন্ট ট্রি তে লিফ নোড গুলোতে কি থাকে? সেখানে থাকে কোনো একটি ইনডেক্সের অরিজিনাল ভ্যালু।

সেগমেন্ট ট্রি তে ইন্টারনাল(লিফ ছাড়া বাকি সব) নোডগুলোতে কি থাকে? সেখানে থাকে নিচে যতগুলো লিফ নোড আছে সবগুলোর 
        
মার্জ করা ফলাফল।


সেগমেন্ট ট্রি তে একটা নোডের রেঞ্জ হলো সেই নোডে যেসব ইনডেক্সের মার্জ করা রেজাল্ট আছে। যেমন ছবিতে ৩ নম্বর নোডের 
        
রেঞ্জ ৫ থেকে ৭।


যেমন উপরের ছবিতে ১০ নম্বর নোডে আছে ৩ নম্বর ইনডেক্সের ভ্যালু আর ২ নম্বর নোডে আছে ১,২,৩,৪ নম্বর নোডের যোগফল। 
        
কি দরকার এতগুলো লিফ নোডে কষ্ট করে গিয়ে আপডেট করে আসা? তার থেকে আমরা কি ২ নম্বর নোডে এসে সেখানে 
        
এই ইনফরমেশনটা রেখে দিতে পারিনা “কারেন্ট নোডের নিচের সবগুলো ইনডেক্সের সাথে x যোগ হবে” ? তার মানে যখন দেখছি 
        
একটা নোডের রেঞ্জ যখন পুরোপুরি কুয়েরির ভিতরে থাকে তখন সেই নোডের নিচে আর না গিয়ে সেখানে প্রপাগেশন ভ্যালুটা সেভ 
        
করে রাখতে পারি। একটা নোডের প্রপাগেশন ভ্যালু হলো সেই নোডের রেঞ্জের মধ্যে সব ইনডেক্সের মধ্যে যে ভ্যালুটা যোগ হবে সেটা।


নিচের ছবিতে দেখো কিভাবে এই এক্সট্রা ইনফরমেশনটা সেভ করা হচ্ছে:


<img src="image/seg_2/2.jpg"/>


প্রতিটি নোডে যোগফল ছাড়াও আরেকটা ভ্যারিয়েবল রাখতে হবে যেটার নাম দিয়েছি propagate। এই ভ্যারিয়েবলটার কাজ হলো তার 
        
নিচের লিফ নোডগুলোর সাথে কত যোগ করতে হবে তার হিসাব রাখা। propagate এর মান শুরুতে থাকে শূন্য। এরপর যে রেঞ্জটা 
        
আপডেট করতে বলবে সেই রেঞ্জের “রিলেভেন্ট নোড” গুলোতে গিয়ে propagate এর সাথে x যোগ করে আসবো। 
        
(আগের পর্বেই জেনেছো “রিলেভেন্ট নোড” হলো যেসব নোডের রেঞ্জ পরোপুরি কুয়েরির ভিতরে আছে)


আরেকটা উদাহরণ, ২ থেকে ৬ নম্বর নোড যদি আপডেট করতে হয় তাহলে হলুদ নোডগুলোতে গিয়ে বলে দিবো নিচের নোডগুলোর 
        
সাথে x যোগ করতে:


<img src="image/seg_2/3.jpg"/>


আগের আপডেট ফাংশনের মতোই কোনো একটা নোড আপডেট করার পর সেই পথের সবগুলো নোড আপডেট করে উঠতে হবে। 
        
আমরা কোডটা দেখি:


<div class="code">
    struct info
    {
        i64 prop,sum;

    }tree[mx*3];  //sum ছাড়াও নিচে অতিরিক্ত কত যোগ হচ্ছে সেটা রাখবো prop এ

    void update(int node,int b,int e,int i,int j,i64 x)
    {
        if (i > e || j < b) 
            return;

        if (b >= i && e <= j)  //নোডের রেঞ্জ আপডেটের রেঞ্জের ভিতরে
        {
            tree[node].sum+=((e-b+1)*x);  //নিচে নোড আছে e-b+1 টি, তাই e-b+1 বার x যোগ হবে এই রেঞ্জে
            tree[node].prop+=x;  //নিচের নোডগুলোর সাথে x যোগ হবে
            return;
        }
        int Left=node*2;
        int Right=(node*2)+1;
        int mid=(b+e)/2;
        update(Left,b,mid,i,j,x);
        update(Right,mid+1,e,i,j,x);
        tree[node].sum=tree[Left].sum+tree[Right].sum+(e-b+1)*tree[node].prop;

        //উপরে উঠার সময় পথের নোডগুলো আপডেট হবে
        //বাম আর ডান পাশের সাম ছাড়াও যোগ হবে নিচে অতিরিক্ত যোগ হওয়া মান

    }

</div>


আগের আপডেট ফাংশনের সাথে পার্থক্য হলো এখন একটা রেঞ্জে আপডেট করছি এবং কোনো নোডের রেঞ্জ আপডেট রেঞ্জের 
        
ভিতরে হলে আমরা নিচে না গিয়ে বলে দিচ্ছি যে নিচের ইনডেক্সগুলোতে x যোগ হবে।


এখন মনে করো আমরা বেশ কয়েকবার আপডেট ফাংশন কল করেছি। নোডগুলোর প্রপাগেটেড ভ্যালুগুলা আপডেট হয়ে 
        
নিচের মতো হয়েছে:


<img src="image/seg_2/4.jpg"/>


যেসব নোডের ভ্যালু লিখিনি সেগুলোতে শুণ্য আছে মনে করো। তাহলে উপরের ছবির মানে হলো ১-৪ ইনডেক্সের সাথে x যোগ হবে, 
        
৫-৭ এর সাথে z যোগ হবে ইত্যাদি।

এবার প্রশ্ন হলো কুয়েরি করবো কিভাবে?


ধরো আমাদের কুয়েরির রেঞ্জ হলো ১-৩। সাধারণভাবে আমরা আমাদের রিলেভেন্ট নোড ৪ আর ১০ থেকে ভ্যালু নিয়ে যোগ করে দিতাম। 
        
কিন্তু আমরা জানি ২ নম্বর নোডের নিচের সবার সাথে x যোগ হয়েছে, তাই ৪ নম্বর নোডের নিচের সবার সাথেও x যোগ হয়েছে! 
        
তাই আমরা ৪ নম্বর রেঞ্জে রাখা ভ্যালুর সাথে যোগ করে দিবো 2*x, কারণ ৪ নম্বর নোডের রেঞ্জে ২টি ইনডেক্স আছে এবং তাদের সবার 
        
সাথে x যোগ হয়েছে। ঠিক একই ভাবে যেহেতু ২ এবং ৫ নম্বর নোডের নিচে আছে ১০, তাই ১০ নম্বর নোডের রেঞ্জ ১টি ইনডেক্স আছে 
        
এবং তার সাথে যোগ হবে (x+y)।


<img src="image/seg_2/5.jpg"/>


তারমানে এটা পরিষ্কার যে কুয়েরি করা সময় কোনো নোডে যাবার সময় উপরের প্রপাগেটেড ভ্যালু গুলার যোগফল সাথে করে নিয়ে 
        
যেতে হবে। তাহলে কুয়েরির ফাংশনে carry নামের একটা প্যারামিটার যোগ করে দেই যার কাজ হবে ভ্যালুটা বয়ে নিয়ে যাওয়া:


<div class="code">
    int query(int node,int b,int e,int i,int j,int carry=0)
    {
        if (i > e || j < b) 
            return 0;

        if(b>=i and e<=j) 
            return tree[node].sum+carry*(e-b+1);   //সাম এর সাথে যোগ হবে সেই রেঞ্জের সাথে অতিরিক্ত 
                                                        যত যোগ করতে বলেছে সেটা

        int Left=node<<1;
        int Right=(node<<1)+1;
        int mid=(b+e)>>1;

        int p1 = query(Left, b,mid, i, j, carry+tree[node].prop);  //প্রপাগেট ভ্যালু বয়ে নিয়ে যাচ্ছে carry ভ্যারিয়েবল
        int p2 = query(Right, mid+1, e, i, j,carry+tree[node].prop);

        return p1+p2;
    }

</div>


আগের কোডের সাথে ডিফারেন্স হচ্ছে carry প্যারামিটারে এবং রিটার্ণভ্যালুতে। শুরুতে হিসাব করে রাখা sum এর সাথে যোগ হচ্ছে 
        
অতিরিক্ত যে ভ্যালু যোগ হয়েছে সেটা।


মোটামুটি এই হলো লেজি প্রপাগেশনের কাহিনী। সামারী করলে দাড়ায়:

১. রেঞ্জের আপডেট O(logn) এ করতে চাইলে লেজি প্রপাগেশন ব্যবহার করতেই হবে।

২. লেজি প্রপাগেশনের কাজ হলো লিফ নোডে আপডেট না করে আগেই কোনো নোড আপডেট রেঞ্জের ভিতরে পড়লে সেখানে বলে 
        
দেয়া নিচের ইনডেক্সগুলো কিভাবে আপডেট হবে।

৩. কুয়েরি করার সময় উপরের নোডগুলোতে সেভ করা প্রপাগেশন ভ্যালুগুলো রিলেভেন্ট নোড ক্যারি করে নিয়ে আসতে হবে এবং 
        
সেই অনুযায়ী ভ্যালু রিটার্ণ করতে হবে।


অনেক সময় প্রবলেমে বলতে পারে একটা রেঞ্জের মধ্যে সবগুলো সংখ্যাকে x দিয়ে বদলে দিতে (x যোগ নয়), সেক্ষেত্রে প্রপাগেশন 
        
ভ্যালু হিসাবে রাখতে হবে নিচের সবনোডকে কোন ভ্যালু দিয়ে বদলে দিতে হবে সেটা। কুয়েরি করার সময় carry ভ্যালুতেও সামান্য 
        
পরিবর্তন আসবে, কিরকম পরিবর্তন আসবে সেটা বের করার দায়িত্ব তোমার উপরে ছেড়ে দিলাম।





    <div class="comment">
Comment
                                <div class="commentbox">
<asp:TextBox ID="textArea" TextMode="MultiLine" style="width:55%; height: 143px;" runat="server"></asp:TextBox>    </div></div>     
                                                                      <asp:Button ID="Button1" runat="server" Text="Comment" Width="86px"></asp:Button>
                             
               </p>
         </pre>


     <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">

        <ItemTemplate>
            <div class="usercomment">
                <div class="commentuser">
       <asp:Label runat="server" ID="LabeUserName" Text='<%#Eval("UserName") %>' ></asp:Label>
                </div>

                <div class="commentcomment">
                  <asp:Label runat="server" ID="LabelComment" Text='<%#Eval("comment") %>'></asp:Label>
                </div>
                </div>
        </ItemTemplate>
     </asp:Repeater>
             </div>           

             </div>

 			<div class="sidebar">
                 
 				<pre>
                    <p>
                        <ul>
 কিছু কথা            
                
                         
<li><a href="https://saadbashar.wordpress.com/2014/08/19/%E0%A6%95%E0%A6%AE%E0%A7%8D%E0%A6%AA%E0%A6%BF%E0%A6%89%E0%A6%9F%E0%A6%BE%E0%A6%B0-%E0%A6%AC%E0%A6%BF%E0%A6%9C%E0%A7%8D%E0%A6%9E%E0%A6%BE%E0%A6%A8/">কম্পিউটার বিজ্ঞান কি??</a></li> 
<li><a href="http://blog.subeen.com/%E0%A6%B8%E0%A6%BF%E0%A6%8F%E0%A6%B8%E0%A6%87-%E0%A6%AC%E0%A6%BF%E0%A6%AD%E0%A6%BE%E0%A6%97%E0%A7%87%E0%A6%B0-%E0%A6%95%E0%A7%8D%E0%A6%B2%E0%A6%BE%E0%A6%B8-%E0%A6%B6%E0%A7%81%E0%A6%B0%E0%A7%81/">সিএসই বিভাগের ক্লাস শুরুর আগে</a></li>
<li><a href="https://saadbashar.wordpress.com/2014/08/19/%E0%A6%95%E0%A7%87%E0%A6%A8-%E0%A6%86%E0%A6%AE%E0%A6%BF-%E0%A6%AA%E0%A7%8D%E0%A6%B0%E0%A7%8B%E0%A6%97%E0%A7%8D%E0%A6%B0%E0%A6%BE%E0%A6%AE%E0%A6%BF%E0%A6%82-%E0%A6%B6%E0%A6%BF%E0%A6%96%E0%A6%AC/">কেন আমি প্রোগ্রামিং শিখবো?</a></li>
<li><a href="http://blog.subeen.com/%E0%A6%AA%E0%A7%8D%E0%A6%B0%E0%A7%8B%E0%A6%97%E0%A7%8D%E0%A6%B0%E0%A6%BE%E0%A6%AE%E0%A6%BF%E0%A6%82-%E0%A6%95%E0%A6%A8%E0%A6%9F%E0%A7%87%E0%A6%B8%E0%A7%8D%E0%A6%9F/">প্রোগ্রামিং কনটেস্ট কি?</a></li> 
<li><a href="http://www.progkriya.org/feature/mirzayanov.html">কেন প্রোগ্রামিং কন্টেস্ট করব? </a></li>
<li><a href="http://www.shafaetsplanet.com/planetcoding/?p=1400">প্রোগ্রামিং কনটেস্ট এবং অনলাইন 
 জাজে হাতেখড়ি </a></li>
<li><a href="http://blog.subeen.com/category/%E0%A6%B8%E0%A6%BE%E0%A6%95%E0%A7%8D%E0%A6%B7%E0%A6%BE%E0%A7%8E%E0%A6%95%E0%A6%BE%E0%A6%B0/">কিছু সাক্ষাৎকার by <a href="https://www.facebook.com/tamim.shahriar.subeen?fref=nf">সুবিন স্যার </a></a></li>

                 
                        
কন্টেস্ট প্রোগ্রামিং সংক্রান্ত যে কোন 
                            
PDF বা CPP ফাইল আপলোড করতে 

চাইলে <a href="file.aspx"> এখানে</a> ক্লিক করুন                           
                            
                            
                   
                            
 আমার লেখা বিভিন্ন অ্যালগোরিদম  
                        
                        
<li><a href="Segment_Tree_1.aspx">সেগমেন্ট ট্রি-১</a></li>     
                            
<li><a href="Segment_Tree_2.aspx">সেগমেন্ট ট্রি-২ (লেজি প্রপাগেশন)</a></li>       
                            
<li><a href="LCA.aspx">লোয়েস্ট কমন অ্যানসেস্টর</a></li>

<li><a href="BIT.aspx">বাইনারি ইনডেক্সড ট্রি</a></li>
                        
                        </ul>  
                        </p>
                </pre>
 			</div>
 		</div>

 		<div class="footer">
             <center>
                  <p>&copy Tanmoy Ghosh</p>
             </center>
 		</div>
 	</div>
 </body>
    </form>
    </html>
