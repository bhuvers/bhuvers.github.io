---
layout: cv
permalink: /cv/
title: resume
nav: true
nav_order: 2
cv_pdf: assets/pdf/BSenthil_ECE_Resume.pdf
description:
toc:
  sidebar: left
---

<style>
  /* Flexbox order to place Education at the top */
  .cv {
    display: flex !important;
    flex-direction: column !important;
  }
  .cv > .card:first-of-type {
    order: 1 !important;
  }
  .cv > a#education,
  .cv > a#education + .card {
    order: 2 !important;
  }
  .cv > a#experience,
  .cv > a#experience + .card {
    order: 3 !important;
  }
  .cv > a#projects,
  .cv > a#projects + .card {
    order: 4 !important;
  }
  .cv > a#skills,
  .cv > a#skills + .card {
    order: 5 !important;
  }

  /* Two-column layout for dates and content — prevent collision */
  .cv .row {
    display: flex !important;
    flex-wrap: nowrap !important;
    align-items: flex-start !important;
  }
  .cv .date-column {
    flex: 0 0 180px !important;
    width: 180px !important;
    max-width: 180px !important;
    min-width: 180px !important;
    text-align: left !important;
    padding-right: 15px !important;
  }
  .cv .date-column table {
    width: 100% !important;
  }
  .cv .date-column .badge {
    display: inline-block !important;
    width: auto !important;
    max-width: 100% !important;
    white-space: nowrap !important;
    text-align: center !important;
    font-size: 0.75rem !important;
    padding: 0.35rem 0.55rem !important;
    letter-spacing: 0.2px !important;
  }
  .cv .date-column + div,
  .cv .col-xs-10 {
    flex: 1 1 auto !important;
    max-width: calc(100% - 180px) !important;
    padding-left: 15px !important;
  }

  /* Role, Degree, and Company typography */
  .cv .title {
    font-size: 1.25rem !important;
    font-weight: 700 !important;
    margin-bottom: 0.2rem !important;
    margin-left: 0 !important;
  }
  .cv h6:not(.title) {
    font-size: 1.1rem !important;
    font-weight: 600 !important;
    margin-bottom: 0.4rem !important;
    margin-left: 0 !important;
    opacity: 0.92;
  }
  .cv ul.items {
    margin-top: 0.4rem !important;
    padding-left: 1.25rem !important;
    list-style-type: disc !important;
  }
  .cv ul.items li {
    margin-bottom: 0.35rem !important;
    line-height: 1.55 !important;
  }

  /* Mobile responsiveness */
  @media (max-width: 768px) {
    .cv .row {
      flex-wrap: wrap !important;
    }
    .cv .date-column {
      flex: 0 0 100% !important;
      max-width: 100% !important;
      width: 100% !important;
      min-width: 0 !important;
      margin-bottom: 0.5rem !important;
    }
    .cv .date-column + div,
    .cv .col-xs-10 {
      flex: 0 0 100% !important;
      max-width: 100% !important;
      padding-left: 0 !important;
    }
  }
</style>

<script>
  (function () {
    function moveEducationTop() {
      var edu = document.getElementById("education");
      var exp = document.getElementById("experience");
      if (edu && exp && edu.parentNode) {
        var eduCard = edu.nextElementSibling;
        exp.parentNode.insertBefore(edu, exp);
        if (eduCard) {
          exp.parentNode.insertBefore(eduCard, exp);
        }
      }
      var toc = document.getElementById("toc-sidebar") || document.querySelector(".toc");
      if (toc) {
        var eduLink = toc.querySelector('a[href="#education"]');
        var expLink = toc.querySelector('a[href="#experience"]');
        if (eduLink && expLink) {
          var eduItem = eduLink.closest("li") || eduLink;
          var expItem = expLink.closest("li") || expLink;
          if (eduItem && expItem && expItem.parentNode) {
            expItem.parentNode.insertBefore(eduItem, expItem);
          }
        }
      }
    }
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", moveEducationTop);
    } else {
      moveEducationTop();
    }
  })();
</script>
