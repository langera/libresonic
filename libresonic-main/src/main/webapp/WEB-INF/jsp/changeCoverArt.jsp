<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>

<html><head>
    <%@ include file="head.jsp" %>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/coverArtService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>

    <script type="text/javascript" language="javascript">

        dwr.engine.setErrorHandler(null);

        function setImage(imageUrl) {
            $("wait").show();
            $("result").hide();
            $("success").hide();
            $("error").hide();
            $("errorDetails").hide();
            $("noImagesFound").hide();
            var id = dwr.util.getValue("id");
            coverArtService.setCoverArtImage(id, imageUrl, setImageComplete);
        }

        function setImageComplete(errorDetails) {
            $("wait").hide();
            if (errorDetails != null) {
                dwr.util.setValue("errorDetails", "<br/>" + errorDetails, { escapeHtml:false });
                $("error").show();
                $("errorDetails").show();
            } else {
                $("success").show();
            }
        }

        function search() {

            $("wait").show();
            $("result").hide();
            $("success").hide();
            $("error").hide();
            $("errorDetails").hide();
            $("noImagesFound").hide();

            var query = "https://www.discogs.com/search/?type=all&q=" + encodeURIComponent(dwr.util.getValue("query"));

            var myWindow = window.open(query, "_blank", "width=800,height=500");
            myWindow.focus();
        }

        function onLoad() {

            $("template").hide();

            search();
        }


    </script>
</head>
<body class="mainframe bgcolor1" onload="javascript:onLoad();">
<h1><fmt:message key="changecoverart.title"/></h1>
<form action="javascript:search()">
    <table class="indent"><tr>
        <td><input id="query" name="query" size="70" type="text" value="${model.artist} ${model.album}" onclick="select()"/></td>
        <td style="padding-left:0.5em"><input type="submit" value="<fmt:message key="changecoverart.search"/>"/></td>
    </tr></table>
</form>

<form action="javascript:setImage(dwr.util.getValue('url'))">
    <table><tr>
        <input id="id" type="hidden" name="id" value="${model.id}"/>
        <td><label for="url"><fmt:message key="changecoverart.address"/></label></td>
        <td style="padding-left:0.5em"><input type="text" name="url" size="50" id="url" value="http://" onclick="select()"/></td>
        <td style="padding-left:0.5em"><input type="submit" value="<fmt:message key="common.ok"/>"></td>
    </tr></table>
</form>
<sub:url value="main.view" var="backUrl"><sub:param name="id" value="${model.id}"/><sub:param name="nocache" value="true"/></sub:url>
<div style="padding-top:0.5em;padding-bottom:0.5em">
    <div class="back"><a href="${backUrl}"><fmt:message key="common.back"/></a></div>
</div>

<h2 id="wait" style="display:none"><fmt:message key="changecoverart.wait"/></h2>
<h2 id="noImagesFound" style="display:none"><fmt:message key="changecoverart.noimagesfound"/></h2>
<h2 id="success" style="display:none"><fmt:message key="changecoverart.success"/></h2>
<h2 id="error" style="display:none"><fmt:message key="changecoverart.error"/></h2>
<div id="errorDetails" class="warning" style="display:none">
</div>

<div id="result">

    <div id="pages" style="float:left;padding-left:0.5em;padding-top:0.5em">
    </div>

    <div id="branding" style="float:right;padding-right:1em;padding-top:0.5em">
    </div>

    <div style="clear:both;">
    </div>

    <div id="images" style="width:100%;padding-bottom:2em">
    </div>

    <div style="clear:both;">
    </div>

</div>

<div id="template" style="float:left; height:190px; width:220px;padding:0.5em;position:relative">
    <div style="position:absolute;bottom:0">
        <a class="search-result-link"><img class="search-result-thumbnail" style="padding:1px; border:1px solid #021a40; background-color:white;"></a>
        <div class="search-result-title"></div>
        <div class="search-result-dimension detail"></div>
        <div class="search-result-url detail"></div>
    </div>
</div>

</body></html>